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
            <li><a href="index.php">Home</a></li>
            <li><a href="projekty.php">Projekty</a></li>
            <li><a href="panel_klienta.php">Panel klienta</a></li>
            <li><a href="sklep.php">Sklep</a>
            <li><a href="kontakt.php">Kontakt</a></li>
            <li><a href="serwis_info.php">O serwisie</a></li>
            <li><a class="active" href="regulamin.php">Regulamin</a></li>
          </ul>
      </menu>
      <main>
        <h1>Regulamin korzystania z serwisu<br><br></h1>
          <ol><li>Niniejsza strona ma charakter wyłacznie prezentujące znajomość PHP, JavaScript, HTML oraz kaskadowych arkuszów stylów<br><br></li>
          <li>Podawanie prawdziwych informacji podczas rejestracji <b>JEST ZABRONIONE</b>. Osoba podająca prawdziwe dane podczas rejestracji zrzeka się jakichkliwiek rozczeń wobec autora serwisu z tytułu ewentualnych naruszeń związanych z wymogami określonymi przez <a href="https://giodo.gov.pl/pl/569/9276">RODO</a><br><br></li>
          <li>W przypadku podania prawdziwych danych wskazane jest (o ile to możliwe) natychmiastowe ich usunięcie. Świadome ich umieszczenie z oczekiwaniem poniesienia przez właściciela serwisu odpowiedzialności naruszają postanowienia punktu 2. <br><br></li>
          <li>Wykorzystane materiały należą do autora serwisu, jest ich współwłaścicielem, bądź otrzymał zgodę na korzystanie z materiałów w celach edukacyjnych - wykorzystanie materiałów w celach zarobkowych, w celach uzyskania z tego tytułu dóbr majątkowych bądź ich upublicznianie jest niedopuszczalne<br><br></li>
          <li>Wykorzystywanie materiałów celach inne niż zarobkowe jest dopuszczalne wyłącznie w przypadkach kiedy:<br><br>
          <ol>
          <li>właściciel danego materiału wyraził zgodę na ich wykorzystanie<br><br></li>
          <li>materiały są wykorzystywane wyłącznie podczas użytkowania serwisu<br><br></li>
          </ol>
          </li>
          <li>Serwis internetowy tworzy integralną całość, wykorzystanie skryptów zawartych wewnątrz plików może odbyć się wyłącznie za zgodą autora <br><br></li>
          <li>Umieszczanie własnych materiałów w serwisie jest dopuszczalne, jednakże wiąże się to z wyrażeniem zgody na przetwarzanie materiałów umieszczonych w serwisie.<br><br></li>
          <li>Grafiki przedmiotów umieszczonych na projekcie zostały uzyskane dzięki pozwoleniu uzyskanemu przez <a href="https://botland.com.pl/pl">Internetowy sklep elektroniczny - Botland - Sklep dla robotyków</a>.
            Serwis wyraził zgodę na wykorzystanie wyłącznie po jednej grafice każdego z przedmiotów do zastosowań akademickich z zastrzeżeniem na
            <a href="https://www.arslege.pl/naruszanie-cudzych-praw-autorskich/k442/a36890/"> Art. 115 Ustawa o prawie autorskim i prawach pokrewnych</a>,
            gdzie oficjalny autor grafikzastrzega sobie własność do grafik do zastosowań komercyjnych<br><br></li>
        </ol>
      </main>
      <br>
      <footer>
             <p>Mateusz Baczek &copy; 2019</p>
         </footer>
</body>
</html>
