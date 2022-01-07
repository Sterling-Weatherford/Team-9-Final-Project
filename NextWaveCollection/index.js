// Instructions
// Run by typing: npm run start

import express from "express";
import exphbs from "express-handlebars";
import bcrypt from "bcrypt";
import cookieParser from "cookie-parser";

import sqlite3 from "sqlite3";
import { open } from "sqlite";

import { grantAuthToken, lookupUserFromAuthToken } from "./auth";

export const dbPromise = open
({
    filename: "data.db",
    driver: sqlite3.Database,
});

const app = express();

app.engine("handlebars", exphbs());
app.set("view engine", "handlebars");

app.use(cookieParser());
app.use(express.urlencoded( { extended: false }));
app.use("/static", express.static(__dirname + "/static")); // css

app.use(async (req, res, next) => 
{
    const { authToken } = req.cookies;
    if(!authToken)
    {
        return next();
    }

    try
    {
        const user = await lookupUserFromAuthToken(authToken);
        req.user = user;
    } 
    catch (e)
    {
        next
        ({
            message: e,
            status: 500
        });
    }

    next();
});

// GET - home (LandingPage)
app.get("/", async (req, res) =>
{
    const db = await dbPromise;

    if(req.user) 
    {
        return res.redirect("/");
    }
    res.render("home");
});

// GET - register (CreateAnAccount)
app.get("/register", (req, res) =>
{
    if(req.user) 
    {
        return res.redirect("/");
    }
    res.render("register");
});

// GET - login (SignIn)
app.get("/login", (req, res) =>
{
    if(req.user) 
    {
        return res.redirect("/");
    }
    res.render("login");
});

// GET - about (AboutPage)
app.get("/about", (req, res) =>
{
    if(req.user)
    {
        return res.redirect("/");
    }
    res.render("about");
});

// GET - yourAccount
app.get("/yourAccount", (req, res) =>
{
    if(req.user)
    {
        return res.redirect("/");
    }
    res.render("yourAccount");
});

// Content GETs - TESTING
app.get("/books", async (req, res) =>
{
    try
    {
        const db = await dbPromise;
        const books = await db.all(`SELECT
        tblBooks.BookName,
        tblBooks.Review,
        tblBooks.Rating,
        tblBooks.CreatorID`);
        if(req.user)
        {
            return res.redirect("/");
        }
        console.log("books", books);
        res.render("home", { books }) // This is where you would load book content - Need to test

    }
    catch (e)
    {
        return res.render("home", { error: e });
    }

});

// Content POSTs - TESTING

// POST - register (CreateAnAccount)
app.post("/register", async (req, res) =>
{
    const db = await dbPromise;
    const
    {
        firstName,
        lastName,
        username,
        email,
        password
    } = req.body;
    const passwordHash = await bcrypt.hash(password, 10);

    try
    {
        await db.run("INSERT INTO tblUsers (FirstName, LastName, Username, Email, Password) VALUES (?, ?, ?, ?, ?);",
        firstName,
        lastName,
        username,
        email,
        passwordHash);

        const user = await db.get("SELECT UserID FROM tblUsers WHERE Username = ?;", username);
        const token = await grantAuthToken(user.id);

        /* Invalid Registration Error
        if(!firstName || !lastName || !username || !email || !passwordHash)
        {
            throw "Invalid Registration";
        }
        */

        res.cookie("authToken", token);
        res.redirect("/");
    }
    catch (e)
    {
        return res.render("register", { error: e });
    }
});

// POST - login (SignIn)
app.post("/login", async (req, res) =>
{
    const db = await dbPromise;
    const
    {
        username,
        password
    } = req.body;

    try
    {
        const existingUser = await db.get("SELECT * FROM tblUsers WHERE Username = ?", username);
        if(!existingUser)
        {
            throw "Incorrect Login";
        }

        const passwordsMatch = await bcrypt.compare(password, existingUser.password);
        if(!passwordsMatch)
        {
            throw "Incorrect Login";
        }

        const token = await grantAuthToken(existingUser.id);
        res.cookie("authToken", token);
        res.redirect("/");
    }
    catch (e)
    {
        return res.render("login", { error: e });
    }
});

// POST - Logout Button
app.post("/logout", async (req, res) => 
{
    const db = await dbPromise;

    if(req.user)
    {
        res.clearCookie("authToken");
    }
    res.redirect("/");
});

// throw 404 error
app.use((err, res, next) =>
{
    next
    ({
        status: 404,
        message: "${req.path} not found"
    });
})

// handle all errors
app.use((err, req, res, next) =>
{
    res.status(err.status || 500)
    console.log(err);
    res.render("errorPage", { error: err.message || err });
});

// Setup
const setup = async () =>
{
    const db = await dbPromise;
    await db.migrate();

    app.listen(8080, () =>
    {
        console.log("listening on http://localhost:8080");
    });
}

setup();