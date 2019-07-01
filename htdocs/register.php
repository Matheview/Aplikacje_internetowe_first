<HTML>
<meta charset="UTF-8" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<style type="text/css">
<?php
session_start();
include("style.css");
?>
</style>
<script type="text/javascript">
<?php
include("scripts.js");
?>
</script>
<title> Elektronik Arts - Rejestracja</title>
</head>
<body>
  <?php
  include("functions.php");
  ?>
  <section class="container">
    <header>
          <ul>
              <li>
                  <a href="index.php">
                      <img src="img/logo.png" alt="logo_strony" id="page-logo"/>
                  </a>
              </li>
              <li>
                  <?php check_login() ?>
              </li>
              <li>
                  <?php basket_info() ?>
              </li>
          </ul>
      </header>
      <menu>
        <div class="logo_big">
          <img src="img/logo_big.png" alt="logo_strony" /></div>
          <div class="menu-page">
            <form method="POST" action="login.php">
            <input type="text" title="wyszukaj w sklepie" name="item">
            <input type="submit" value="Wyszukaj" name="search">
            </form>
          </div>
        <div class="menu-bar">
          <ul>
            <li><a href="index.php">Home</a></li>
            <li><a href="projekty.php">Projekty</a></li>
            <li><a class="active" href="panel_klienta.php">Panel klienta</a></li>
            <li><a href="sklep.php">Sklep</a>
            <li><a href="kontakt.php">Kontakt</a></li>
            <li><a href="serwis_info.php">O serwisie</a></li>
            <li><a href="regulamin.php">Regulamin</a></li>
          </ul>
      </menu>
      <main>
        <?php
        if (isset($_GET['registered'])) {
          registered();
        }
        else {
          $args = isset($_GET['attempt']);
          panel_klienta($args);
        } ?>
      </main>
      <br>
      <footer>
             <p>Mateusz Baczek &copy; 2019</p>
      </footer>
    </body>
</html>
