const { Router } = require('express')
const router = Router();
const admin = require('firebase-admin');
const db = admin.firestore();

// Create Wlc
router.post('/api/wlcs', (req, res) => {
    (async () => {
        try {
            await db
                .collection('Wlcs').doc('/' + req.body.mac + '/')
                .create({
                    manufacturer_name: req.body.manufacturer_name,
                    network_id:        req.body.network_id,
                    product_name:      req.body.product_name
                })
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read all Wlc
router.get('/api/wlcs', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Wlcs');
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                mac:               doc.id,
                network_id:        doc.data().network_id,
                manufacturer_name: doc.data().manufacturer_name,
                product_name:      doc.data().product_name
            }))
            return res.status(200).json(response);   
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read Wlc by Network
router.get('/api/network/:network_id/wlcs', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Wlcs').where("network_id", "==", req.params.network_id);
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                mac:               doc.id,
                network_id:        doc.data().network_id,
                manufacturer_name: doc.data().manufacturer_name,
                product_name:      doc.data().product_name
            }))
            return res.status(200).json(response);
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read Wlc
router.get('/api/wlc/:wlc_id', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Wlcs').doc(req.params.wlc_id);
            const item = await doc.get();
            const response = item.data();
            const exists = response !== undefined;
            return res.status(exists ? 200 : 400).json({
                success: exists,
                data: exists ? response : "not found"
            })
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Delete Wlc
router.delete('/api/wlcs/:mac', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Wlcs').doc(req.params.mac);
            await doc.delete();
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Update Wlc
router.put('/api/wlcs/:mac', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Wlcs').doc(req.params.mac);
            await doc.update({
                manufacturer_name: req.body.manufacturer_name,
                product_name:      req.body.product_name
            });
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

module.exports = router