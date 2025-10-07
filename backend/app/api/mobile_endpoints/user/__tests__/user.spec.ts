import request from 'supertest';
import app from '../../../../app.js';
import { db } from '../../../../../test/setup.db.js';
describe('User API', () => {
    it('should return a list of users', async () => {
        const res = await request(app).get('/mobile-api/user');
        expect(res.status).toBe(200);
    });

  it('should return a list of users', async () => { 
    await db.query("INSERT INTO users (name, email, password) VALUES (?, ?, ?)", ['John Doe', 'john.doe@example.com', 'password']);
    await db.query("INSERT INTO users (name, email, password) VALUES (?, ?, ?)", ['Jane Doe', 'jane.doe@example.com', 'password']);
    const res = await request(app).get('/mobile-api/user/check-db-user');
    expect(res.status).toBe(200);
    expect(res.body).toBeDefined();
    expect(res.body.length).toBe(2);
    expect(res.body[0].name).toBe('John Doe');
    expect(res.body[0].email).toBe('john.doe@example.com');
    expect(res.body[0].password).toBe('password');
    expect(res.body[1].name).toBe('Jane Doe');
    expect(res.body[1].email).toBe('jane.doe@example.com');
    expect(res.body[1].password).toBe('password');
  });
});
