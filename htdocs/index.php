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
<title> Elektronik Arts </title>
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
            <li><a class="active" href="index.php">Home</a></li>
            <li><a href="projekty.php">Projekty</a></li>
            <li><a href="panel_klienta.php">Panel klienta</a></li>
            <li><a href="sklep.php">Sklep</a>
            <li><a href="kontakt.php">Kontakt</a></li>
            <li><a href="serwis_info.php">O serwisie</a></li>
            <li><a href="regulamin.php">Regulamin</a></li>
          </ul>
      </menu>
      <main>
      <?php
      $is_logout = isset($_GET['logout']);
      if($is_logout != NULL) {
        echo("Do zobaczenia");
      }
      else {
        random_message();
      }
      ?>
      <br><br><br>
      <article>
          <section class="home-article">
              <h1>Arduino</h1>
              <p>Arduino nie trzeba nikomu przedstawiać. Znane i lubiane układy wraz z modułami i akcesoriami.
              Arduino to prosty komputer, jednak jego możliwości są ogromne, a dodatkowe akcesoria i rozszerzenia pozwalają
              zwiększyć jego funkcjonalność. Za jego pomocą można samodzielnie stworzyć np.
              domową stację meteorologiczną czy też sterownik do obsługi rolet w oknach.</p>
          </section>
          <section class="parent">
              <img src="img/technology-3209268_1920.jpg" alt="" class="image-article" />
          </section>
      </article>
      <article>
          <section class="home-article">
              <h1>Physical computing - namacalne przetwarzanie</h1>
              <p>Arduino jest jednym z elementów, nowego trendu, tak zwanego physical computing albo przetwarzania namacalnego. Rozwój mikrokontrolerów a przede wszystkim rozwój oprogramowania open source sprawił, że dla znacznie szerszego grona stały się dostępne narzędzia, dzięki którym powstają projekty z pogranicza elektroniki, oprogramowania, multimediów. Innymi słowy - nowe podejście do możliwości jakie daje nam technika cyfrowa</p>
          </section>
          <section class="parent">
              <img src="img/technology-1784564_1920.jpg" alt="" class="image-article" />
          </section>
      </article>
      <article>
          <section class="home-article">
              <h1>RaspberryPi</h1>
              <p>Popularny minikomputer Raspberry Pi. Uznawany za jeden z najciekawszych i najbardziej rewolucyjnych wynalazków ostatnich lat. Zaskakująco małe rozmiary i ogromne możliwości. Raspberry Pi to komputerowa platforma, urządzenie składające się z pojedynczego obwodu drukowanego. Przedstawiona została w roku 2012, a stworzona przez Raspberry Pi Foundation.</p>
          </section>
          <section class="parent">
              <img src="img/products/raspberry-pi-572481_1280.jpg" alt="" class="image-article" />
          </section>
      </article>
      <article>
          <section class="home-article">
              <h1>Arduino - moduły główne</h1>
              <p>Moduły główne Arduino są przeznaczone dla początkujących i doświadczonych programistów. Arduino jest platformą dla systemów wbudowanych. Większość z nich opiera się na 8-bitowych mikrokontrolerach, z wyjątkiem Arduino Due, który ma 32-bitowy rdzeń ARM Cortex. Moduły można ze sobą łączyć, wykorzystując do tego ogólnodostępne przewody połączeniowe</p>
          </section>
          <section class="parent">
              <img src="img/arduino-2233042_1920.jpg" alt="" class="image-article" />
          </section>
      </article>
    </main>
    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
      <footer>
             <p>Mateusz Baczek &copy; 2019</p>
      </footer>
    </body>
</html>
