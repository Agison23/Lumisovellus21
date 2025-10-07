import request from 'supertest';
import app from '../app/app.js';

describe('App root', () => {
  it('GET / should return welcome text', async () => {
    
    const res = await request(app).get('/');
    expect(res.status).toBe(200);
    expect(res.text).toMatch(/Welcome to Api Backend!/);
  });
});


