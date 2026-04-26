

console.log("SERVER FILE LOADED");
const express = require('express');
const { getUsersByEmail } = require('./userService');
const bcrypt = require('bcrypt');
const db = require('./db');

const app = express();
app.use(express.json());

app.use((req, res, next) => {
  console.log("➡️ REQUEST:", req.method, req.url);
  next();
});

app.post('/test', (req, res) => {
  console.log("TEST POST HIT");
  res.json({ ok: true });
});




app.post('/login', async (req, res) => {
    console.log("LOGIN ROUTE HIT");
  const { email, password } = req.body;

  console.log("REQUEST RECEIVED");
  console.log("Email:", email);
  console.log("Password:", password);

  const user = await getUsersByEmail(email);

  console.log("USER FROM DB:", user);

  if (!user){
    return res.status(401).json({success: false});
  }

  const match = await bcrypt.compare(password, user.passwordHash);

  if(!match) {
    return res.status(401).json({ success: false, message: "Invalid credentials" });
  }

  console.log("LOGIN SUCCESS");

  res.json({
    success: true,
    user: {
        id: user.id,
        name: user.userName,
        email: user.email,
        role: user.docRole 
    }
  });
});
////////////////////////////////////////////
//const bcrypt = require('bcrypt');

app.post('/register', async (req, res) => {

    const { email, password, name, role } = req.body;

    if (!email || !password || !name) {
        return res.status(400).json({ 
        success: false, 
        message: "Missing fields" 
        });
    }

  try {

    const hashedPassword = await bcrypt.hash(password, 10);

    await db.query(
      "INSERT INTO users (userName, email, docRole, passwordHash) VALUES (?, ?, ?, ?)",
      [name, email, role, hashedPassword]
    );

    res.json({ success: true });

  } catch (err) {
    console.log("REGISTER ERROR:", err);
    res.status(500).json({ success: false });
  }
});
/////////////////////////////////////////////////////////////////
app.listen(3000, () => {
  console.log("Server running on port 3000");
});