import { v4 as uuidv4 } from "uuid";
import { dbPromise } from "./index";

export const grantAuthToken = async (userId) =>
{
    const db = await dbPromise;
    const tokenString = uuidv4();
    await db.run("INSERT INTO AuthTokens (token, UserID) VALUES (?, ?);",
    tokenString, userId);

    return tokenString;
}

export const lookupUserFromAuthToken = async (authToken) =>
{
    const db = await dbPromise;
    const token = await db.get("SELECT * FROM AuthTokens WHERE token = ?;", authToken);
    if(!token)
    {
        return null;
    }
    const user = await db.get("SELECT UserID, Email, Username FROM tblUsers WHERE UserID = ?;", token.userId);
    
    return user;
}