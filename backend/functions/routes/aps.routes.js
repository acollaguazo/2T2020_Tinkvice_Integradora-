const { Router } = require('express')
const router = Router();

const admin = require('firebase-admin');

const db = admin.firestore();

// Create Ap
router.post('/api/aps', (req, res) => {
    (async () => {
        try {
            await db
                .collection('Aps').doc('/' + req.body.mac + '/')
                .create({
                    wlc_id  : req.body.wlc_id,
                    network_id : req.body.network_id,
                    name    : req.body.name,
                    model   : req.body.model,
                    piso    : '0',
                    devices : '0',
                    limit   : '10',
                    dx      : '0',
                    dy      : '0',
                    active  : '0'
                })
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read all Ap
router.get('/api/aps', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Aps');
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                mac        : doc.id,
                network_id : doc.data().network_id,
                wlc_id     : doc.data().wlc_id,
                model      : doc.data().model,
                name       : doc.data().name,
                piso       : doc.data().piso,
                devices    : doc.data().devices,
                limit      : doc.data().limit,
                dx         : doc.data().dx,
                dy         : doc.data().dy,
                active     : doc.data().active
            }))
            return res.status(200).json(response);   
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read Ap
router.get('/api/aps/:ap_id', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Aps').doc(req.params.ap_id);
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

// Read Ap by Wlc
router.get('/api/wlc/:wlc_id/aps', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Aps').where("wlc_id", "==", req.params.wlc_id);
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                mac        : doc.id,
                wlc_id     : doc.data().wlc_id,
                network_id : doc.data().network_id,
                model      : doc.data().model,
                name       : doc.data().name,
                piso       : doc.data().piso,
                devices    : doc.data().devices,
                limit      : doc.data().limit,
                dx         : doc.data().dx,
                dy         : doc.data().dy,
                active     : doc.data().active
            }))
            return res.status(200).json(response);
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read Ap by Network
router.get('/api/network/:network_id/aps', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Aps').where("network_id", "==", req.params.network_id);
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                mac        : doc.id,
                wlc_id     : doc.data().wlc_id,
                network_id : doc.data().network_id,
                model      : doc.data().model,
                name       : doc.data().name,
                piso       : doc.data().piso,
                devices    : doc.data().devices,
                limit      : doc.data().limit,
                dx         : doc.data().dx,
                dy         : doc.data().dy,
                active     : doc.data().active
            }))
            return res.status(200).json(response);
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});


// Delete Ap
router.delete('/api/aps/:mac', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Aps').doc(req.params.mac);
            await doc.delete();
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Update Model & Name of Ap
router.put('/api/aps/:mac/model/name', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Aps').doc(req.params.mac);
            await doc.update({
                model: req.body.model,
                name : req.body.name
            });
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Update limit & piso of Ap
router.put('/api/aps/:mac/limit/piso', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Aps').doc(req.params.mac);
            await doc.update({
                limit : req.body.limit,
                piso  : req.body.piso
            });
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Update devices of Ap
router.put('/api/aps/:mac/devices', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Aps').doc(req.params.mac);
            await doc.update({
                devices: req.body.devices,
            });
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Update dx & dy of Ap
router.put('/api/aps/:mac/dxdy', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Aps').doc(req.params.mac);
            await doc.update({
                dx: req.body.dx,
                dy: req.body.dy,
                
            });
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Update active of Ap
router.put('/api/aps/:mac/active', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Aps').doc(req.params.mac);
            await doc.update({
                active: req.body.active,
            });
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

module.exports = router