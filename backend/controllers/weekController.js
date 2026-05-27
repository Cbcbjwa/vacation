//Imports
const { 
    createWeek,
    loadWeeks,
    updateWeek,
    deleteWeek,
} = require("../services/weekService");

//Method for adding new weeks
async function addWeek(req, res) {
    const { weekNumber, weekDate, specialSpecification, totalSlots } = req.body;

    if(weekNumber == null || !weekDate || totalSlots == null) {
        return res.status(400).json({ success: false, message: "Missing fields" });
    }

    try {
        await createWeek(weekNumber, weekDate, specialSpecification, totalSlots);
        res.json({ success: true });
    } catch (error) {
        console.log("ADD WEEK ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for loading weeks
async function getWeeks(req, res) {
  try {
    const weeks = await loadWeeks();
    console.log("CONTROLLER OUTPUT:", weeks);
    res.json(weeks);
  } catch (error) {
    console.log("GET WEEKS ERROR:", error);
    res.status(500).json({ error: "Failed to load weeks" });
  }
}

console.log("WEEK ROUTES LOADED");
console.log("loadWeeks import:", loadWeeks);

//Method for updating weeks
async function update(req, res) {
    const { weekId, weekNumber, weekDate, specialSpecification, totalSlots } = req.body;

    try {
        await updateWeek(weekId, weekNumber, weekDate, specialSpecification, totalSlots);
        res.json({ success: true });
    } catch (error) {
        console.log("UPDATE ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for deleting weeks
async function remove(req, res) {
    const { weekId } = req.params;

    try {
        await deleteWeek(weekId);
        res.json({ success: true });
    } catch (error) {
        console.log("REMOVE WEEK ERROR: ", error);
        res.status(500).json({ success: false });
    }
}


module.exports = { addWeek, getWeeks, update, remove };