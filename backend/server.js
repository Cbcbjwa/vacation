console.log("SERVER FILE LOADED");

const express = require("express");

const userRoutes = require("./routes/userRoutes");
const authRoutes = require("./routes/authRoutes");
const weekRoutes = require("./routes/weekRoutes");

const app = express();

app.use(express.json());

// logger middleware
app.use((req, res, next) => {
  console.log("➡️", req.method, req.url);
  next();
});

//Routes
app.use("/users", require("./routes/userRoutes"));
app.use("/auth", authRoutes);
app.use("/weeks", require("./routes/weekRoutes"));
app.use("/sites", require("./routes/siteRoutes"));
app.use("/selections", require("./routes/selectionRoutes"));

app.listen(3000, () => {
  console.log("Server running on port 3000");
});