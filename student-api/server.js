const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

let students = [];

// Load existing students from a JSON file
fs.readFile('students.json', (err, data) => {
  if (err) throw err;
  students = JSON.parse(data);
});

// Save students to a JSON file
const saveStudents = () => {
  fs.writeFile('students.json', JSON.stringify(students, null, 2), (err) => {
    if (err) throw err;
  });
};

// Get all students
app.get('/api/students', (req, res) => {
  res.json(students);
});

// Add a new student
app.post('/api/students', (req, res) => {
  const newStudent = req.body;
  students.push(newStudent);
  saveStudents();
  res.status(201).json(newStudent);
});

// Update a student
app.put('/api/students/:index', (req, res) => {
  const index = req.params.index;
  students[index] = req.body;
  saveStudents();
  res.json(students[index]);
});

// Delete a student
app.delete('/api/students/:index', (req, res) => {
  const index = req.params.index;
  const deletedStudent = students.splice(index, 1);
  saveStudents();
  res.json(deletedStudent);
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
