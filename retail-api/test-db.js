const { getConnection } = require('./db');

async function testConnection() {
    let connection;

    try {
        connection = await getConnection();

        const result = await connection.execute(
            `SELECT 1 AS TEST_VALUE FROM DUAL`
        );

        console.log('Oracle connection successful!');
        console.log(result.rows);

    } catch (error) {
        console.error('Oracle connection failed:');
        console.error(error.message);

    } finally {
        if (connection) {
            await connection.close();
        }
    }
}

testConnection();