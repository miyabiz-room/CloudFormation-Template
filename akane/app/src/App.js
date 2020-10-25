import './App.css';
import React, { useState, useEffect } from 'react';
import { API } from "aws-amplify";
import { withAuthenticator } from "@aws-amplify/ui-react";
import {
  createTodo,
  updateTodo,
  deleteTodo
} from './graphql/mutations';
import { listTodos } from './graphql/queries'

function App() {
  const [id, setId] = useState('');
  const [note, setNote] = useState('');
  const [todos, setTodos] = useState([]);

  useEffect(() => {
    fetchData();
  }, []);
  const fetchData = async () =>  {
    const result = await API.graphql({query: listTodos});
    setTodos(result.data.listTodos.items);
  }

  const handleOnChangeNote = event => {
    setNote(event.target.value);
  }

  const handleAddTodo = async event => {
    event.preventDefault();

    if (hasExistingTodo()) {
      handleUpdateTodo();
    } else {
      const input = { note };
      const result = await API.graphql({query: createTodo, variables: { input: input }});
      console.log(result);
      const newTodo = result.data.createTodo;
      const updatedTodos = [newTodo, ...todos];
      setTodos(updatedTodos);
      setNote('');
    }
  }

  const handleUpdateTodo = async () => {
    const input = { id, note };
    const result = await API.graphql({query: updateTodo, variables: { input: input }});
    console.log(result);
    const updatedTodo = result.data.updateTodo;
    const index = todos.findIndex(todo => todo.id === updatedTodo.id);
    const updatedTodos = [
      ...todos.slice(0, index),
      updatedTodo,
      ...todos.slice(index + 1)
    ];
    setTodos(updatedTodos);
    setNote('');
  }

  const handleDeleteTodo = async todoId => {
    const input = { id: todoId };
    const result = await API.graphql({query: deleteTodo, variables: { input: input }});
    const deletedTodoId = result.data.deleteTodo.id;
    const updatedTodos = todos.filter(todo => todo.id !== deletedTodoId);
    setTodos(updatedTodos);
  }

  const handleSetNote = ({ id, note }) => {
    setId(id);
    setNote(note);
  }

  const hasExistingTodo = () => {
    if (id) {
      const isTodo = todos.findIndex(todo => todo.id === id) > -1;
      return isTodo;
    }
    return false;
  }

  return (
    <div className="flex flex-column items-center justify-center pa3 bg-washed-red">
      <h1 className="code f2-l">
        Amplify Todos
      </h1>
      {/* Note Form */}
      <form onSubmit={handleAddTodo} className="mb3">
        <input
          type="text"
          className="pa2 f4"
          placeholder="Write your todo"
          onChange={handleOnChangeNote}
          value={note}
        />
        <button className="pa2 f4" type="submit">
          { id ? "Update Todo" : "Add Todo" }
        </button>
      </form>

      {/* Note List */}
      <div>
      {todos.map(item => (
        <div key={item.id} className="flex items-center">
          <li onClick={() => handleSetNote(item)} className="list pa1 f3">
            {item.note}
          </li>
          <button
            onClick={() => handleDeleteTodo(item.id)}
            className="bg-transparent bn f4"
          >
            <span>&times;</span>
          </button>
        </div>
      ))}
      </div>
    </div>
  );
}

export default withAuthenticator(App, {
  includeGreetings: true
});
