import os
import boto3
import setSlackWebHook

ec2 = boto3.client('ec2', region_name=os.environ['AWS_REGION'])

def handler(event, context):
    slack_message = ''
    running_instance_ids = []
    for instance_id, info in get_all_ec2_instances_info().items():
        # Nameがない場合
        if 'Name' not in info['tags']:
            info['tags']['Name'] = 'Nameなし'

        # 起動しているインスタンス
        if info['state'] == 'running':
            print ('x  :', instance_id, ' ', info['tags']['Name'], '(', info['lifecycle'], ')')
            # POST情報を生成
            if slack_message == '':
                slack_message = "以下のインスタンスが起動してたため、休止しました\n"
                slack_message = slack_message + "instance-id : Name(Lifecycle)\n"
            slack_message = slack_message + "{} : {}({})\n".format(instance_id, info['tags']['Name'], info['lifecycle'])
            # 起動しているインスタンス情報
            running_instance_ids.append(instance_id)
        else:
            print ('o  :', instance_id, ' ',info['tags']['Name'], '(', info['lifecycle'], ')')
    if len(running_instance_ids) > 0:
        # インスタンス休止
        response = ec2.stop_instances(
            InstanceIds=running_instance_ids
        )
    if len(slack_message) > 0:
        # Slack通知
        setSlackWebHook.set_slack_webhook(
            os.environ['SLACK_WEB_HOOK_URL'],
            os.environ['SLACK_CHANNEL'],
            slack_message
        )

def get_all_ec2_instances_info():
    """[全てのec2インスタンスのタグ情報を取得する]

    Returns:
        [dict]: [インスタンスIDをキーとしたタグ情報]]
    """
    # ec2インスタンス一覧表示
    instances = ec2.describe_instances()
    instance_dict = {}
    for reservations in instances['Reservations']:
        for instance in reservations['Instances']:
            tags = parse_keyvalue_sets(instance['Tags'])
            instance_dict[instance['InstanceId']] = dict(
                tags=tags,
                state=instance['State']['Name'],
                lifecycle=instance.get('InstanceLifecycle', 'normal')
            )
    return instance_dict

def parse_keyvalue_sets(tags):
    """[Tagsリストのパースをする]

    Args:
        tags ([dict]]): [Key/Valueを含む値]

    Returns:
        [dict]: [タグのName/値のみ]
    """
    return {tag['Key']: tag['Value'] for tag in tags}