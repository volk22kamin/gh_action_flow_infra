function buildMongoUriFromParts() {
    const user = process.env.MONGO_USER;
    const pass = process.env.MONGO_PASSWORD;
    const host = process.env.MONGO_HOST || "localhost";
    const db   = process.env.MONGO_DB   || "todoapp";
    if (!user || !pass) return null; 
    return `mongodb://${encodeURIComponent(user)}:${encodeURIComponent(pass)}@${host}:27017/${db}?authSource=admin`;
}

const isTestEnv = process.env.NODE_ENV === "test";

const fullUri = process.env.MONGODB_URI;

const partsUri = buildMongoUriFromParts();

const uri =
fullUri ??
partsUri ??
(isTestEnv
    ? "mongodb://localhost:27017/todoapp_test"
    : "mongodb://localhost:27017/todoapp");

export { uri };
