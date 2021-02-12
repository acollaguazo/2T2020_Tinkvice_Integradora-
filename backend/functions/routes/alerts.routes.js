const { Router } = require('express')
const router = Router();
const admin = require('firebase-admin');
const db = admin.firestore();

router.post('/api/alerts', async (req, res) => {
    (async () => {
        try {
            await db
                .collection('Alerts').doc()
                .create({
                    network_id:   req.body.network_id,
                    area:          req.body.area,
                    hour:          req.body.hour,
                    date:          req.body.date,
                    device_number: req.body.device_number
                })
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read Alerts by Network
router.get('/api/network/:network_id/alerts', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Alerts').where("network_id", "==", req.params.network_id);
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                id:            doc.id,
                area:          doc.data().area,
                hour:          doc.data().hour,
                date:          doc.data().date,
                device_number: doc.data().device_number
            }))
            return res.status(200).json(response);   
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

router.delete('/api/alerts/:id', (req, res) => {

    (async () => {
        try {
            const doc = db.collection('Networks').doc(req.body.network_id)
                          .collection('Alerts').doc(req.params.id)
            await doc.delete();
            return res.status(200).json();   
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

router.put('/api/alerts/:id', (req, res) => {
    (async () => {
        try {
            const doc = db.collection('Networks').doc(req.body.network_id)
                          .collection('Alerts').doc(req.params.id);
            await doc.update({
                description: req.body.description,
                hour:        req.body.hour,
                date:        req.body.date
            });
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

module.exports = router