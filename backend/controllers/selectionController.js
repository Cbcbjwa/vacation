//Imports
const { 
    createSelection,
    loadSelections,
    updateSelection,
    deleteSelection,
    getSelectionByUserAndRound,
    getSelectionsByUser
} = require("../services/selectionService");

//Method for adding new selections
async function addSelection(req, res) {

    console.log("REQ BODY:", req.body);

    const { userId, weekId, roundNumber} = req.body;

    if(userId == null || weekId == null || roundNumber == null) {
        return res.status(400).json({ success: false, message: "Missing fields" });
    }

    try {
        const result = await createSelection(userId, weekId, roundNumber);
        res.json({ success: true,
            selection: {
                selectionId: result.insertId,
                userId,
                weekId,
                roundNumber
            }
         });

    } catch (error) {
        console.log("ADD SELECTION ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for loading selections
async function getSelections(req, res) {
    try {
        const selections = await loadSelections();

        console.log("SELECTION CONTROLLER OUTPUT:", selections);

         res.json({
            success: true,
            selections
        });

    } catch (error) {
        console.log("GET SELECTIONS ERROR:", error);
        res.status(500).json({ error: "Failed to load selections" });
    }
}

//Method for updating selections
async function update(req, res) {
    const { selectionId, weekId } = req.body;

    try {
        await updateSelection(selectionId, weekId);
        res.json({ success: true });
    } catch (error) {
        console.log("UPDATE ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for deleting selections
async function remove(req, res) {
    const { selectionId } = req.params;

    try {
        await deleteSelection(selectionId);
        res.json({ success: true });
    } catch (error) {
        console.log("REMOVE SELECTION ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for getting a SINGULAR selection
async function getSelection(req, res) {
    const { userId, roundNumber } = req.params;

    try {
        const selection = await getSelectionByUserAndRound(userId, roundNumber);

        res.json({
            success: true,
            selection: selection || null
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({ success: false });
    }
}

//Method to load all the selections of an individual user
async function getUserSelections(req, res) {
    const { userId } = req.params;

    const selections = await getSelectionsByUser(userId);

    res.json({
        success: true,
        selections
    });
}

module.exports = { addSelection, getSelections, update, remove, getSelection, getUserSelections };