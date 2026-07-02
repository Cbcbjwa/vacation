require("dotenv").config();


console.log("SERVER FILE LOADED");

const express = require("express");
const cors = require("cors");

const userRoutes = require("./routes/userRoutes");
const authRoutes = require("./routes/authRoutes");
const weekRoutes = require("./routes/weekRoutes");

//Lottery service object
const LotteryService = require("./services/lotteryService");
const lotteryService = new LotteryService();

const app = express();

app.use(express.json());

//Flutter thing
app.use(cors());

//Logger middleware
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
app.use("/lottery", require("./routes/lotteryRoutes"));

app.get("/", (req, res) => {
  res.send("Vacation API is running!");
});


//Server port
const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  console.log(`Server running on port ${PORT}`);

  //If there was an active timer when the server shut down, recreating the setInterval and continuing it.
  await lotteryService.resumeTimerIfNeeded();
});