const { Router } = require('express')
const router = Router();
const admin = require('firebase-admin');
const db = admin.firestore();

// Create User
router.post('/api/users', (req, res) => {
    (async () => {
        try {
            await db
                .collection('Users').doc().create({
                    user:       req.body.user,
                    network_id: req.body.network_id,
                })
            return res.status(200).json();
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// // Read all User
// router.get('/api/users', (req, res) => {
//     (async () => {
//         try {
//             const query = db.collection('Users');
//             const querySnapshot = await query.get();
//             const docs = querySnapshot.docs;
//             const response = docs.map(doc => ({
//                 mac:               doc.id,
//                 network_id:        doc.data().network_id,
//                 manufacturer_name: doc.data().manufacturer_name,
//                 product_name:      doc.data().product_name
//             }))
//             return res.status(200).json(response);   
//         } catch (error) {
//             console.log(error);
//             return res.status(500).send(error)
//         }
//     })();
// });

// Read User by Network
router.get('/api/network/:network_id/users', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Users').where("network_id", "==", req.params.network_id);
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                id:         doc.id,
                network_id: doc.data().network_id,
                user:       doc.data().user,
            }))
            return res.status(200).json(response);
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// Read User by Name
router.get('/api/name/:name/users', (req, res) => {
    (async () => {
        try {
            const query = db.collection('Users').where("user", "==", req.params.name);
            const querySnapshot = await query.get();
            const docs = querySnapshot.docs;
            const response = docs.map(doc => ({
                network_id: doc.data().network_id,
                user:       doc.data().user,
            }))
            return res.status(200).json(response);
        } catch (error) {
            console.log(error);
            return res.status(500).send(error)
        }
    })();
});

// // Delete User
// router.delete('/api/users/:mac', (req, res) => {
//     (async () => {
//         try {
//             const doc = db.collection('Users').doc(req.params.mac);
//             await doc.delete();
//             return res.status(200).json();
//         } catch (error) {
//             console.log(error);
//             return res.status(500).send(error)
//         }
//     })();
// });

// // Update User
// router.put('/api/users/:mac', (req, res) => {
//     (async () => {
//         try {
//             const doc = db.collection('Users').doc(req.params.mac);
//             await doc.update({
//                 manufacturer_name: req.body.manufacturer_name,
//                 product_name:      req.body.product_name
//             });
//             return res.status(200).json();
//         } catch (error) {
//             console.log(error);
//             return res.status(500).send(error)
//         }
//     })();
// });

module.exports = router