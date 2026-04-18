<!DOCTYPE html>
<html>
<head>
    <title>DevOps Test Registration version 2</title>
    <style>
        body {
            font-family: Arial;
            background: #f4f6f9;
        }

        .container {
            width: 400px;
            margin: auto;
            background: white;
            padding: 25px;
            margin-top: 40px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px #ccc;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #218838;
        }

        .footer {
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>

<body>

<div class="container">
    <h2> v1 DevOps Learning - Test Form</h2>

    <form action="test_submit.php" method="POST">

        <label>Full Name</label>
        <input type="text" name="name" placeholder="Enter your full name" required>

        <label>Mobile Number</label>
        <input type="tel" name="mobile" placeholder="Enter mobile number" required>

        <label>Email Address</label>
        <input type="email" name="email" placeholder="Enter email" required>

        <label>Choose Course</label>
        <select name="course">
            <option>DevOps Beginner</option>
            <option>Advanced Kubernetes</option>
            <option>AWS + CI/CD</option>
        </select>

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter password" required>

        <label>Confirm Password</label>
        <input type="password" name="confirm_password" placeholder="Confirm password" required>

        <button type="submit"> <a href="https://www.epicdope.com/wp-content/uploads/2021/12/Eren-Yeager.jpg">Login here</a></p></button>

    </form>

    <div class="footer">
        <p>Already registered? <a href="https://www.epicdope.com/wp-content/uploads/2021/12/Eren-Yeager.jpg">Login here</a></p>
    </div>

    <hr>
   
</div>

</body>
</html>
