#!/usr/bin/env node

/**
 * Comprehensive Test Runner for Lumisovellus Backend
 * Cross-platform Node.js version
 */

const { spawn, exec } = require('child_process');

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m',
};

function log(level, message) {
  const timestamp = new Date().toISOString().split('T')[1].split('.')[0];
  const color = colors[level] || colors.reset;
  // eslint-disable-next-line no-console
  console.log(`${color}[${timestamp}] ${message}${colors.reset}`);
}

function checkDocker() {
  return new Promise((resolve, reject) => {
    exec('docker info', (error) => {
      if (error) {
        log('red', 'Docker is not running. Please start Docker first.');
        reject(error);
      } else {
        log('green', 'Docker is running');
        resolve();
      }
    });
  });
}

function checkTestDb() {
  return new Promise((resolve) => {
    exec('docker ps --format "{{.Names}}"', (error, stdout) => {
      if (stdout.includes('lumisovellus-testdb')) {
        log('green', 'Test database container is running');
        resolve(true);
      } else {
        log('yellow', 'Test database container not running');
        resolve(false);
      }
    });
  });
}

function startTestDb() {
  return new Promise((resolve, reject) => {
    log('blue', 'Starting test database...');

    const dockerCompose = spawn(
      'docker',
      ['compose', '-f', 'docker-compose.test.yml', 'up', '-d'],
      { stdio: 'inherit' }
    );

    dockerCompose.on('close', (code) => {
      if (code === 0) {
        log('green', 'Test database started');
        waitForDb().then(resolve).catch(reject);
      } else {
        reject(new Error(`Docker compose failed with code ${code}`));
      }
    });
  });
}

function waitForDb() {
  return new Promise((resolve, reject) => {
    log('blue', 'Waiting for database to be ready...');

    let attempts = 0;
    const maxAttempts = 30;

    const checkDb = () => {
      attempts++;

      exec(
        'docker exec lumisovellus-testdb mysqladmin ping -h localhost --silent',
        (error) => {
          if (error && attempts < maxAttempts) {
            log(
              'blue',
              `Attempt ${attempts}/${maxAttempts} - Waiting for database...`
            );
            global.setTimeout(checkDb, 2000);
          } else if (error) {
            reject(new Error('Database failed to start within expected time'));
          } else {
            log('green', 'Database is ready!');
            resolve();
          }
        }
      );
    };

    checkDb();
  });
}

function setupDbSchema() {
  return new Promise((resolve, reject) => {
    log('blue', 'Setting up database schema...');

    const npm = spawn('npm', ['run', 'test:db:setup'], { stdio: 'inherit' });

    npm.on('close', (code) => {
      if (code === 0) {
        log('green', 'Database schema setup complete');
        resolve();
      } else {
        reject(new Error(`Database schema setup failed with code ${code}`));
      }
    });
  });
}

function runTests() {
  return new Promise((resolve, reject) => {
    log('blue', 'Running all tests...');
    console.log('');

    const npm = spawn('npm', ['run', 'test:db'], { stdio: 'inherit' });

    npm.on('close', (code) => {
      if (code === 0) {
        log('green', 'All tests passed! 🎉');
        resolve();
      } else {
        log('red', 'Some tests failed ❌');
        reject(new Error(`Tests failed with code ${code}`));
      }
    });
  });
}

function cleanup() {
  return new Promise((resolve) => {
    log('blue', 'Cleaning up...');

    const dockerCompose = spawn(
      'docker',
      ['compose', '-f', 'docker-compose.test.yml', 'down'],
      { stdio: 'inherit' }
    );

    dockerCompose.on('close', () => {
      log('green', 'Cleanup complete');
      resolve();
    });
  });
}

async function main() {
  const args = process.argv.slice(2);
  const keepDb = args.includes('--keep-db');
  const showHelp = args.includes('--help') || args.includes('-h');

  if (showHelp) {
    console.log('Usage: node run-tests.js [options]');
    console.log('Options:');
    console.log('  --keep-db    Keep test database running after tests');
    console.log('  --help, -h   Show this help message');
    process.exit(0);
  }

  console.log('🧪 Lumisovellus Backend Test Runner');
  console.log('==================================');

  try {
    // Check Docker
    await checkDocker();

    // Check if test DB is already running
    const dbRunning = await checkTestDb();

    if (!dbRunning) {
      await startTestDb();
      await setupDbSchema();
    } else {
      log('blue', 'Test database already running, skipping setup');
    }

    // Run tests
    await runTests();

    console.log('');
    console.log('==================================');
    log('green', 'Test run completed successfully! ✅');
  } catch (error) {
    console.log('');
    console.log('==================================');
    log('red', `Test run failed: ${error.message} ❌`);
    process.exit(1);
  } finally {
    if (!keepDb) {
      await cleanup();
    }
  }
}

// Handle process termination
process.on('SIGINT', async () => {
  log('yellow', 'Received SIGINT, cleaning up...');
  await cleanup();
  process.exit(1);
});

process.on('SIGTERM', async () => {
  log('yellow', 'Received SIGTERM, cleaning up...');
  await cleanup();
  process.exit(1);
});

main().catch(async (error) => {
  log('red', `Unexpected error: ${error.message}`);
  await cleanup();
  process.exit(1);
});
