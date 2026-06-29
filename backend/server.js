require("dotenv").config();


console.log("SERVER FILE LOADED");

const express = require("express");
const cors = require("cors");

const userRoutes = require("./routes/userRoutes");
const authRoutes = require("./routes/authRoutes");
const weekRoutes = require("./routes/weekRoutes");

const app = express();

app.use(express.json());

//Flutter thing
app.use(cors());

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
app.use("/rounds", require("./routes/roundRoutes"))
app.use("/sysState", require("./routes/sysStateRoutes"));
app.use("/email", require("./routes/emailRoutes"));
app.use("/timerState", require("./routes/timerStateRoutes"));

app.get("/", (req, res) => {
  res.send("Vacation API is running!");
});


//Server port
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});