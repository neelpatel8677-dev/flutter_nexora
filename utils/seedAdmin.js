require('dotenv').config();
const mongoose = require('mongoose');
const User = require('../models/User');
const connectDB = require('../config/db');

const seedAdmin = async () => {
  try {
    await connectDB();

    const adminExists = await User.findOne({ role: 'admin' });

    if (adminExists) {
      console.log('Admin already exists');
      process.exit(0);
    }

    const admin = await User.create({
      name: 'System Admin',
      email: process.env.ADMIN_EMAIL || 'admin@nexora.com',
      password: process.env.ADMIN_PASSWORD || 'Admin@123',
      role: 'admin',
      phone: '9999999999',
    });

    console.log('Admin created successfully:');
    console.log(`Email: ${admin.email}`);
    console.log(`Password: ${process.env.ADMIN_PASSWORD || 'Admin@123'}`);
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

seedAdmin();
