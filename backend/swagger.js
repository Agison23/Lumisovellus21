import swaggerAutogen from 'swagger-autogen';
const doc = {
    info: {
        version: 'v1.0.0',
        title: 'API Documentation',
        description: 'API Documentation'
    },
    host: `localhost:${process.env.PORT || 8000}`,
    basePath: '/',
    schemes: ['http', 'https'],
};
const outputFile = './swagger-output.json';
const endpointsFiles = ['./apps/index.ts'];
const swaggerAutogenInstance = swaggerAutogen();
swaggerAutogenInstance(outputFile, endpointsFiles, doc);
//# sourceMappingURL=swagger.js.map