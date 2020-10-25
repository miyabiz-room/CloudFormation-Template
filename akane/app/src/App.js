import React, { useState } from 'react';
import {
  AppBar,
  Toolbar,
  Typography,
  Box,
  Grid,
  TextField,
  Button,
  TableContainer,
  Table,
  TableHead,
  TableBody,
  TableRow,
  TableCell,
  Paper,
  makeStyles,
  withStyles,
  CircularProgress,
} from '@material-ui/core';
import { Alert } from '@material-ui/lab';
import axios from 'axios';

const apigwEndpoint = process.env.REACT_APP_APIGW_ENDPOINT;
const apiKey = process.env.REACT_APP_API_KEY;

function App() {
  const StyledTableCell = withStyles((theme) => ({
    head: {
      backgroundColor: theme.palette.common.black,
      color: theme.palette.common.white,
    },
    body: {
      fontSize: 14,
    },
  }))(TableCell);
  const StyledTableRow = withStyles((theme) => ({
    root: {
      '&:nth-of-type(odd)': {
        backgroundColor: theme.palette.action.hover,
      },
    },
  }))(TableRow);
  const useStyles = makeStyles({
    table: {
      minWidth: 200,
    },
  });
  const classes = useStyles();
  const createData = (girlName, value) => {
    return { girlName, value };
  }

  const [isLoading, setIsLoading] = useState(false);
  const [fetchDone, setFetchDone] = useState(false);
  const [tableRows, setTableRows] = useState([]);
  const [successMsg, setSuccessMsg] = useState('');
  const [errorMsg, setErrorMsg] = useState('');

  const getWhisper = () => {
    setIsLoading(true);
    setSuccessMsg('');
    setErrorMsg('');

    const name = document.getElementById('name').value;

    axios
      .get(`${apigwEndpoint}${name}`, {
        headers: {
          "Content-Type": "application/json",
          "X-Api-Key": apiKey
        }
      })
      .then((api_results) => {
        console.log(api_results);

        if (api_results.status !== 200) {
          setFetchDone(false);
          setErrorMsg('APIの取得が正常にできませんでした');
        }
        const girlName = Object.keys(api_results.data.result)[0];
        const rows = [
          createData(girlName, api_results.data.result[girlName])
        ];
        setSuccessMsg(api_results.data.message);
        setTableRows(rows);
        setFetchDone(true);
      })
      .catch(() => {
        setErrorMsg('通信に失敗しました。名前をご確認ください');
        setFetchDone(false);
      })
      .finally(() => {
        setIsLoading(false);
      });
  };

  return (
    <>
      <AppBar position="static">
        <Toolbar>
          <Typography>キャストのつぶやきアプリ</Typography>
        </Toolbar>
      </AppBar>
      <Box m={10} />
      <Grid container alignItems="center" justify="center">
        <Grid item xs={2}>
          <TextField
            required
            id="name"
            label="名前"
            variant="outlined"
          />
        </Grid>
        <Grid item xs={1}>
          <Button variant="contained" color="primary" onClick={getWhisper}>CONFIRM</Button>
        </Grid>
      </Grid>
      <Box m={10} />
      <Grid container alignItems="center" justify="center">
        <Grid item xs={2}>
          {successMsg.length > 0 && <Alert severity="success">{successMsg}</Alert>}
          {errorMsg.length > 0 && <Alert severity="error">{errorMsg}</Alert>}
          {isLoading && <CircularProgress />}
        </Grid>
      </Grid>
      <Box m={10} />
    <Grid container alignItems="center" justify="center">
      <Grid item xs={5}>
        {fetchDone && <TableContainer component={Paper}>
          <Table className={classes.table} aria-label="simple table">
            <TableHead>
              <TableRow>
                <StyledTableCell>キャスト名</StyledTableCell>
                <StyledTableCell align="center">つぶやき</StyledTableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {tableRows.map(row => (
                <StyledTableRow key={row.girlName}>
                  <StyledTableCell component="th" scope="row">
                    {row.girlName}
                  </StyledTableCell>
                  <StyledTableCell align="center">{row.value}</StyledTableCell>
                </StyledTableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>}
      </Grid>
    </Grid>
    <Box m={10} />
    </>
  );
}

export default App;
