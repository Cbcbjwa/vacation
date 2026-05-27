//Imports
const { 
    createSite,
    loadSites,
    updateSite,
    deleteSite,
} = require("../services/siteService");

//Method for adding new sites
async function addSite(req, res) {
    const { siteName, maxDocsOffPerWeek } = req.body;

    if(!siteName || maxDocsOffPerWeek == null) {
        return res.status(400).json({ success: false, message: "Missing fields" });
    }

    try {
        await createSite(siteName, maxDocsOffPerWeek);
        res.json({ success: true });
    } catch (error) {
        console.log("ADD SITE ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for loading sites
async function getSites(req, res) {
    try {
        const sites = await loadSites();
        console.log("SITE CONTROLLER OUTPUT:", sites);
        res.json(sites);
    } catch (error) {
        console.log("GET SITES ERROR:", error);
        res.status(500).json({ error: "Failed to load sites" });
    }
}

console.log("SITES ROUTES LOADED");
console.log("loadSites import:", loadSites);

//Method for updating sites
async function update(req, res) {
    const { siteId, siteName, maxDocsOffPerWeek } = req.body;

    try {
        await updateSite(siteId, siteName, maxDocsOffPerWeek);
        res.json({ success: true });
    } catch (error) {
        console.log("UPDATE ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

//Method for deleting sites
async function remove(req, res) {
    const { siteId } = req.params;

    try {
        await deleteSite(siteId);
        res.json({ success: true });
    } catch (error) {
        console.log("REMOVE SITE ERROR: ", error);
        res.status(500).json({ success: false });
    }
}

module.exports = { addSite, getSites, update, remove };
