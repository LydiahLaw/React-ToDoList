import React, { useState, useEffect } from 'react';

const API_BASE = 'http://localhost:3000/api/todos';

const TodoList = () => {
  const [tasks, setTasks] = useState([]);
  const [task, setTask] = useState('');

  // Fetch tasks
  const fetchTasks = async () => {
    const res = await fetch(API_BASE);
    const data = await res.json();
    setTasks(data);
  };

  useEffect(() => {
    fetchTasks();
  }, []);

  // Add task
  const addTask = async () => {
    if (!task.trim()) return;
    const res = await fetch(API_BASE, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ text: task }),
    });
    const newTask = await res.json();
    setTasks([newTask, ...tasks]);
    setTask('');
  };

  // Toggle completion
  const toggleTask = async (id, completed) => {
    const res = await fetch(`${API_BASE}/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ completed: !completed }),
    });
    const updated = await res.json();
    setTasks(tasks.map(t => (t._id === id ? updated : t)));
  };

  // Delete task
  const deleteTask = async (id) => {
    await fetch(`${API_BASE}/${id}`, { method: 'DELETE' });
    setTasks(tasks.filter(t => t._id !== id));
  };

  return (
    <div className="container">
      <input
        type="text"
        placeholder="Enter task"
        value={task}
        onChange={(e) => setTask(e.target.value)}
      />
      <button onClick={addTask}>Add</button>

      <h3>Today's Tasks</h3>
      <ul>
        {tasks.map((item) => (
          <li key={item._id}>
            <input
              type="checkbox"
              checked={item.completed}
              onChange={() => toggleTask(item._id, item.completed)}
            />
            <span className="task-text">{item.text}</span>
            <button onClick={() => deleteTask(item._id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default TodoList;

