const express = require('express');
const multer = require('multer');
const cors = require('cors');

const app = express();
const upload = multer({ dest: 'uploads/' });

app.use(cors());

app.post('/generate', upload.single('image'), (req, res) => {
  console.log('Image received:', req.file.originalname);
  // Balikin dummy hasil gambar
  return res.json({
    success: true,
    output_url: 'https://via.placeholder.com/512x512.png?text=Redesigned+Room'
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
