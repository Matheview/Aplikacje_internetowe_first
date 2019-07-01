<?php
function check_login() {
  if (isset($_SESSION['logged']) && $_SESSION['logged'] === true && isset($_SESSION['user'])) {
      echo('<li><div id="item_ilosc" style="margin-right: 30;">
      <form name="logout" method="post" action="login.php?logout=true">
      <input type="hidden" id="prod_id" value="logout"/>
      <span class="butn" onclick="logout.submit()">Wyloguj</span></form></div></li>');
  }
  else {
    echo ('<form method="POST" action="login.php">
    <input type="text" title="email" name="login">
    <input type="password" title="hasło" name="haslo">
    <input type="submit" value="Zaloguj" name="loguj">
    <input type="submit" value="Zarejestruj" name="register">
    </form>');
  }
}
function basket_info() {
  if (isset($_SESSION['box_items'])){
    echo('<div><a href="sklep.php?card_box=true"><img src="img/wozek.png" title="Zobacz swój koszyk"></a><b>'.sizeof($_SESSION['box_items']).'</b></div>');
  }
  else {
    echo('<div><a href="sklep.php?card_box=true"><img src="img/wozek.png" title="Twój koszyk jest pusty..."></a></div>');
  }
}

function finish_order() {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  $query = mysqli_query($conn, "SELECT MAX(basket_id) as basket_id FROM basket");
  $max = $query->fetch_assoc();
  $max['basket_id'] += 1;
  $unique = array_unique($_SESSION['box_items']);
  foreach($unique as $item) {
    $i = 0;
    foreach($_SESSION['box_items'] as $var) {
      if($var == $item){ $i++;}
    }
    mysqli_query($conn, "INSERT INTO basket(basket_id, product_id, quantity, created_at) VALUES (".$max['basket_id'].",
                (SELECT product_id FROM products WHERE product_num=".$item."), ".$i.",NOW())");
    mysqli_query($conn, "UPDATE products SET quantity=quantity-".$i.", updated_at=NOW() WHERE product_num=".$item);
  }
  mysqli_query($conn, "INSERT INTO orders(basket_id, user_id, order_price_type, kurier_id, order_price_sum, created_at) VALUES (".$max['basket_id'].",
              ".$_SESSION['user_id'].", ".$_SESSION['payment'].", ".$_SESSION['sender'].", ".$_SESSION['price_sum'].", NOW())");
  unset($_SESSION['box_items']);
  unset($_SESSION['price_sum']);
  echo('<h1>Gratulacje!</h1><br><br>Wszystko gotowe, poinformujemy Cię kiedy przesyłka będzie gotowa<br>Dziękujemy Ci za zaufanie i do zobaczenia wkrótce <img src="img/robo_paka.png" style="float: right;"><script type="text/javascript">auto_redirect();</script>');
}

function send_box() {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  echo('<h1>Podsumowanie</h1><br>');
  if (isset($_SESSION['box_items'])) {
    $str_query = implode(", ", $_SESSION['box_items']);
    $result = mysqli_query($conn, "SELECT product_id, product_num, prod_name, price, price_old, picture, CASE WHEN quantity<=0 THEN 'brak'
      WHEN quantity between 1 AND 5 THEN 'malo' WHEN quantity between 6 AND 9 THEN 'dostepny' WHEN quantity between 10 AND 14 THEN 'duzo'
      WHEN 15<=quantity THEN 'bardzo' END as quantity, CASE WHEN quantity<=0 THEN 'Brak na magazynie' WHEN quantity between 1 AND 5 THEN 'Pozostało mało sztuk'
      WHEN quantity between 6 AND 9 THEN 'Dostępny' WHEN quantity between 9 AND 14 THEN 'Dużo w asortymencie' WHEN 15<=quantity THEN 'Bardzo dużo' END as quantity_desc,
      description_short, description_long, warehouse_date FROM products WHERE product_num in ($str_query.)");
    $payment = mysqli_query($conn, "SELECT description, price FROM pay_type WHERE pay_type_id=".$_SESSION['payment']);
    $kurier = mysqli_query($conn, "SELECT description, logo, price FROM couriers WHERE kurier_id=".$_SESSION['sender']);
    $pay = $payment->fetch_assoc();
    $kur = $kurier->fetch_assoc();
    echo('<h4>Wybrane produkty:</h4><br><table id="shop_table" style="margin-left: -100;">');
    $_SESSION['price_sum'] = 0;
    foreach($result as $row) {
      $i = 0;
      foreach($_SESSION['box_items'] as $var){
        if($var == $row['product_num']){ $i++;}
      }
      echo('<tr><td width=40% style="padding-bottom:30px"><a href="sklep.php?product='.$row['product_num'].'"><img src="img/products/'.$row['picture'].'"></a></td><td><br><br><h4><a href="sklep.php?product='.$row['product_num'].'">'.$row['prod_name']."</a></h4>".$row['description_short'].
            '<br><div id="item_ilosc"><img src="img/items_'.$row['quantity'].'.png" alt="'.$row['quantity_desc'].'" title="'.$row['quantity_desc'].'"></div>');
      if ($row['price_old'] != NULL) {
        echo('<div id="old_price">'.$row['price_old'].'   </div>');
      }
      $_SESSION['price_sum'] += $row['price']*$i;
      echo('<div id="price_item">'.$row['price'].'zł<br><div id="item_count">Ilość:'.$i.'</div></div>');
    }
    echo('</td></tr></table>');
    $_SESSION['price_sum'] = $_SESSION['price_sum']+$kur['price']+$pay['price'];
    echo('<table style="margin: 0; width: 92%;"><tr><td><h4>Wybrana forma płatności: </h4><br>'.$pay['description'].'<br><br><br><br></td><td><div id="price_item">'.number_format($pay['price'], 2, '.', '').'zł</div></td></tr>
        <tr><td><h4>Wybrana forma przesyłki: </h4><br>'.$kur['description'].'<br><img src="img/couriers/'.$kur['logo'].'" style="width: 20%; float: left;" title="'.$kur['description'].'"><br><br><br></td><td><div id="price_item">'.number_format($kur['price'], 2, '.', '').'zł</div></td></tr>
        <tr><td colspan="2"><div style="float: right; margin-right: 30;"><br><br><br><h2>Suma: <div id="price_item">'.number_format($_SESSION['price_sum'], 2, '.', '').'zł</h2></div></div></td></tr>
        <tr><td colspan="2"><br><br><div style="float: right;">
        <form name="completed" method="post" action="login.php?completed=true"><input type="hidden" id="prod_id" value="completed"/><span class="butn" onclick="completed.submit()">Gotowe</span></form></div></div><br><br><br><br></td></tr></table></td></tr></table>');
    mysqli_close($conn);
  }
}

function complete_box() {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  $_SESSION['price_send'] = 0;
  $_SESSION['price_pay'] = 0;
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  $payment = mysqli_query($conn, "SELECT pay_type_id, description, price, before_payment FROM pay_type ORDER BY pay_type_id");
  $sender = mysqli_query($conn, "SELECT kurier_id, description, logo, price FROM couriers ORDER BY kurier_id");
  echo('<h1>Wybierz sposób płatności i rodzaj wysyłki</h1><br><br>
  <h2> Sposób płatności:</h1>
  <br>
  <table style="width: 50%;"><form name="send_box" method="post" action="login.php?send_box=true">');
  $ckecked = 0;
  foreach($payment as $pay){
    echo('<tr style="line-height: 30px; border-bottom:1pt solid black;"><td colspan="2">'.$pay['description'].' </td><td width="20%"><input type="radio" name="payment" value="'.$pay['pay_type_id'].'" title="'.$pay['description'].'"');
    if ($ckecked == 0){ echo('checked'); $ckecked = 1;}
    echo('><span class="checkmark"></span></td><td>'.number_format($pay['price'], 2, '.', '').' zł</td></tr>');
  }
  echo('<tr><td><br><br><br><br><h2> Przesyłka:</h1><br></td></tr>');
  $ckecked = 0;
  foreach($sender as $send){
    echo('<tr><td width="10%"><img src="img/couriers/'.$send['logo'].'" style="float: left; max-width: 80%;"></td><td style="float: left; margin: 0; margin-top: 20;">'.$send['description'].' </td><td width="20%">
    <input type="radio" name="sender" value="'.$send['kurier_id'].'" title="'.$send['description'].'"');
    if ($ckecked == 0) { echo('checked'); $ckecked = 1;}
    echo('></td><td>'.number_format($send['price'], 2, '.', '').'zł</td></tr>');
  }
  if ((!isset($_SESSION['logged'])) || (isset($_SESSION['logged']) && $_SESSION['logged'] === false)) {
    echo('<tr><td colspan="4"><br><br><br><br><div style="float:right;"><a href="panel_klienta.php">Zaloguj się lub zarejestruj aby przejść dalej...</a></div><br><br><br><br></td></tr></table>');
  }
  elseif (isset($_SESSION['logged']) && $_SESSION['logged'] === true) {
    echo('<tr><td colspan="4"></div></div><br><br><br><br>
    <div id="item_ilosc" style="float: right;">
    <input type="hidden" id="prod_id" value="completed"/><span class="butn" onclick="send_box.submit()">Podsumowanie</span></form></div></div><br><br><br><br></td></tr></table>');
  }
}

function accept_box(){
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  $_SESSION['price_send'] = 0;
  $_SESSION['price_pay'] = 0;
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
}

function render_box() {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  echo('<h1>Twój koszyk</h1>');
  if (isset($_SESSION['box_items'])) {
    $str_query = implode(", ", $_SESSION['box_items']);
    $result = mysqli_query($conn, "SELECT product_id, product_num, prod_name, price, price_old, picture, CASE WHEN quantity<=0 THEN 'brak'
      WHEN quantity between 1 AND 5 THEN 'malo' WHEN quantity between 6 AND 9 THEN 'dostepny' WHEN quantity between 10 AND 14 THEN 'duzo'
      WHEN 15<=quantity THEN 'bardzo' END as quantity, CASE WHEN quantity<=0 THEN 'Brak na magazynie' WHEN quantity between 1 AND 5 THEN 'Pozostało mało sztuk'
      WHEN quantity between 6 AND 9 THEN 'Dostępny' WHEN quantity between 9 AND 14 THEN 'Dużo w asortymencie' WHEN 15<=quantity THEN 'Bardzo dużo' END as quantity_desc,
      description_short, description_long, warehouse_date FROM products WHERE product_num in ($str_query.)");
      echo('<table id="shop_table">');
      $_SESSION['price_sum'] = 0;
      foreach($result as $row) {
        $i = 0;
        foreach($_SESSION['box_items'] as $var){
          if($var == $row['product_num']){ $i++;}
        }
        echo('<tr><td width=40% style="padding-bottom:30px"><a href="sklep.php?product='.$row['product_num'].'"><img src="img/products/'.$row['picture'].'"></a></td><td><br><br><h4><a href="sklep.php?product='.$row['product_num'].'">'.$row['prod_name']."</a></h4>".$row['description_short'].
              '<br><div id="item_ilosc"><img src="img/items_'.$row['quantity'].'.png" alt="'.$row['quantity_desc'].'" title="'.$row['quantity_desc'].'"></div>');
        if ($row['price_old'] != NULL) {
          echo('<div id="old_price">'.$row['price_old'].'   </div>');
        }
        $_SESSION['price_sum'] += $row['price']*$i;
        echo('<div id="price_item">'.$row['price'].'zł<br><div id="item_count">Ilość: '.$i.'</div></div>');
        if ($row['warehouse_date'] === NULL) {
          echo('<table style="width: 30%;"><tr><td><div id="item_ilosc"><form name="add_box'.$row['product_id'].'" method="post" action="login.php?add_box='.$row['product_num'].'"><input type="hidden" id="prod_id" value="'.$row['product_num'].'"/><span class="butn" onclick="add_box'.$row['product_id'].'.submit()">Dodaj</span></form></div></td>
          <td><div id="item_ilosc"><form name="remove_box'.$row['product_id'].'" method="post" action="login.php?remove_box='.$row['product_num'].'"><input type="hidden" id="prod_id" value="'.$row['product_num'].'"/><span class="butn_remove" onclick="remove_box'.$row['product_id'].'.submit()">Usuń</span></form></div></td></tr></table>');
        }
        else {
          $date = date_create($row['warehouse_date']);
          echo('<h5>Przewidywany termin dostawy: '.date_format($date, 'Y-m-d').'</h5>');
        }
        echo('</td></tr>');
      }
      mysqli_close($conn);
  }
  else {
    echo('<br><h2>Twój koszyk jest pusty...</h2><br><img src="img/robo_not_found.png">');
  }
  if ((!isset($_SESSION['logged'])) || (isset($_SESSION['logged']) && $_SESSION['logged'] === false && isset($_SESSION['box_items']))) {
    echo('<tr><td colspan="2"><br><br><br><br><div style="float: right; margin-right: 30;"><h2>Suma: <div id="price_item">'.$_SESSION['price_sum'].'zł</h2></div></div><br><br><br><br><div style="float:right;"><a href="panel_klienta.php">Zaloguj się lub zarejestruj aby przejść dalej...</a></div></td></tr></table>');
  }
  if (isset($_SESSION['logged']) && $_SESSION['logged'] === true && isset($_SESSION['box_items'])) {
    echo('<tr><td colspan="2"><br><br><br><br><div style="float: right; margin-right: 30;"><h2>Suma: <div id="price_item">'.$_SESSION['price_sum'].'zł</h2></div></div><br><br><br><br>
    <div id="item_ilosc" style="float: right;"><form name="complete_box'.$row['product_id'].'" method="post" action="login.php?complete_box=true">
    <input type="hidden" id="prod_id" value="'.$row['product_num'].'"/><span class="butn" onclick="complete_box'.$row['product_id'].'.submit()">Przejdź dalej
    </span></form></div></td></tr></table>');
  }
}

function random_message() {
  $message = array("Czy znasz to uczucie kiedy chcąc położyć się spać nagle zdajesz sobie sprawę, że zostawiłeś w pokoju włączone
                        światło? Czy widząc oferty firm z propozycjami sterowania oświetleniem łapiesz się za głowę zadając pytanie,
                        czy musi to być takie drogie? Nasz serwis umożliwi Ci znalezienie rozwiązania, które kosztuje Cię tylko przygotowaniem
                        materiałów do zrealizowania tego celu. Jeżeli nie możesz znaleźć rozwiązania napisz do Nas! Na pewno Ci pomożemy",
                   "Jesteś majsterkowiczem, przesiadujesz wolne popołudnia w garażu próbując realizować nietypowe pomysły? Jesteś we właściwym miejscu!
                        Nasz serwis posiada asortyment, dzięki któremu nie tylko zrealizujesz swoje pomysły, ale też znajdziesz natchnienie na wykonanie kolejnych.
                        Nie możesz znaleźć interesujących Ciebie materiałów? Projekty, które chciałbyś zrealizować nie są dostępne w naszej bazie? Napisz do Nas!
                        Ciekawe pomysły na pewno uzupełnią naszą bazę projektów!",
                   "Masz dość przeszukiwania internetu w poszukiwaniu elektroniki, która będzie po prostu działała? Oferty innych sprzedawców wydają się być Tobie podejrzane?
                        Znamy to! Nasz serwis powstał właśnie dla takich jak Ty! Chcesz realizować swoje pomysły bez obaw o wadliwe części - to oczywiste. Posiadamy w asortymencie
                        oryginalne części sprawdzonych producentów. Zarejestruj się i sprawdź!",
                   "Interesują Cię nowe technologie? Może sztuczna inteligencja? Szukasz materiałów do rozwijania swoich umiejętności? Znajdziesz u nas także i materiały od
                        sprawdzonych autorów. Nie chcesz tracić czasu na czytanie nudnych książek, w których połowa to tylko 'lanie wody' - no własnie. Interesuje Ciebie tylko co
                        potrzebne i sprawdzone. Zarejestruj się i sprawdź!",
                   "Lubisz domówki, ale większość z Twoich znajomych uważa Ciebie za nerda? Może chcesz stworzyć klimat taki jak na jednym z Twoich ulubionych koncertów, ale nie masz pieniędzy?
                        Kolorowe światła przypominają gimnazjalne dyskoteki na których i tak większość
                        podpierała ściany? A może tak wzmacniacz z Equalizerem 3D, lasery midające w rytm muzyki, hologramy. znajdziesz tutaj także i elementy, które pozwolą Ci
                        stworzyć niezapomniane domówki. Zarejestruj się i sprawdź naszą ofertę! Teraz jedynie czego Ci brakuje to dobrej muzyki, towarzystwa... reszta
                        to już Twój własny pomysł.",
                    "Posiadasz ogródek, ale nie masz czasu pilnować roślinek przed wyschnięciem, które potrzebują szczególnej opieki? Znajdziesz tutaj rozwiązania, które pomogą Ci
                        utrzymać rośliny w dobrej kondycji. Jedynie czego potrzebujesz to chwili wolnego czasu, chęci i Naszych części. Posiadamy asortyment, który pozwoli Ci
                        zadbać o rośliny nawet wtedy, kiedy przez dłuższy czas nie ma Cię w domu. Zarejestruj się i sprawdź!",
                    "Kręci Cię automatyka? CHciałbyś kiedyś stworzyć swoją maszyhę CNC, ploter, drukarkę 3D, ale nie masz ochoty siedzieć godzinami w internecie przeszukując
                        interesujących Ciebie części? Zarejestruj się i sprawdź naszą ofertę! Znajdziesz tutaj interesujące Ciebie projekty! Wszystkie części potrzebne do ich
                        wykonania znajdziesz właśnie u Nas! Sprawdź!",
                    "Arduino, RaspberryPi, DigiSpark, RockPi? Mówią Ci coś te nazwy? Może jeszcze nie wiesz czym są, ale widziałeś masę pomysłów, które także chciałbyś zrealizować?
                        Nasz serwis posiada szeroki asortyment elektroniki, mikrokomputerów, mikrokontrolerów, które pomogą CI zrealizować Twoje pomysły! Zarejestruj się i sprawdź!");
  echo("<br><br>".$message[rand(0, sizeof($message)-1)]);
}

function panel_klienta($args) {
  if (!isset($_SESSION['logged']) || $_SESSION['logged'] === false || $args != NULL) {
    echo('<div><h1>Zarejestruj się<br><br></h1>');
      if (isset($args) && $args != NULL){
        echo('<div id="error_login">Nie znaleziono użytkownika o podanych danych<br></div>
        Nie pamiętasz hasła? Kliknij <a href="generate_password.php">tutaj</a> aby wygenerować nowe<br><br>');
      }
      echo('<form method="POST" action="login.php">
          <table border=0 width=35%>
          <tr><td width=28%><b>Imię </b></td><td><input type="text" pattern="[A-Za-z]{2,}" title="imię" name="name" required></td></tr>
          <tr><td><b>Nazwisko </b></td><td><input type="text" pattern="[A-Za-z]{2,}" title="nazwisko" name="surname" required></td></tr>
          <tr><td><b>E-mail </b></td><td><input type="email" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="e-mail" name="e-mail" required></td></tr>
          <tr><td><b>Hasło </b></td><td><input type="password" title="hasło" name="haslo" onchange="this.setCustomValidity(this.validity.patternMismatch ? "Hasło nie moze być puste i posiadać przynajmniej 6 znaków" : ""); if(this.checkValidity()) form.haslo_confirm.pattern = this.value;"required></td></tr>
          <tr><td><b>Powtórz hasło </b></td><td><input type="password" title="potwierdz hasło" name="haslo_confirm" onchange="this.setCustomValidity(this.validity.patternMismatch ? "Podane hasła nie pasują do siebie" : "");" required></td></tr>
          <tr><td><b>Miasto </b></td><td><input type="text" title="city" name="city" required></td></tr>
          <tr><td><b>Ulica, nr domu </b></td><td><input type="text" title="street" name="street" required></td></tr>
          <tr><td><b>Telefon </b></td><td><input type="text" title="telefon" name="phone_num" required></td></tr>
          <tr><td><b>Kod pocztowy </b></td><td><input type="text" pattern="^[0-9]{2}-[0-9]{3}$" title="kod pocztowy" name="kod_pocztowy" required></td></tr>
          <tr><td colspan="2"><br><input type="checkbox" name="regulamin" value="rules" required> Zaznaczając tą opcję akceptujesz <a href="regulamin.php">warunki</a> korzystania z serwisu</td></tr>
          <tr><td></td><td><br><input type="submit" value="Zarejestruj" name="register"></td></tr>
        </table>
      </form><style="float: right;"><img src="img/robo_hello.png"></style></div>');
  }
  elseif (isset($_SESSION['logged']) && isset($_SESSION['user'])) {
    $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
    $conn->set_charset("utf-8");
    mysqli_query($conn, "SET NAMES utf8");
    mysqli_query($conn, "SET CHARACTER SET utf8");
    mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
    echo('<B>Witaj '.$_SESSION['user'].'!  </b><br><br><br>');
    $result = mysqli_query($conn, "SELECT o.order_id, o.basket_id, k.logo, k.description as k_desc, o.order_price_sum, p.description as p_desc, o.completed_at, CASE WHEN o.sended=true THEN 'Wysłano' WHEN o.sended IN (false, NULL) THEN 'W toku' END as sended, created_at
                  FROM orders o
                  INNER JOIN couriers k ON o.kurier_id=k.kurier_id
                  INNER JOIN pay_type p ON o.order_price_type=p.pay_type_id
                  WHERE user_id=".$_SESSION['user_id']);
    if (mysqli_num_rows($result) == 0) {
      echo('Nie złożyłes jeszcze żadnych zamówień!<br><img src="img/robo_not_found.png" style="float: left; margin-bottom: 10%;">');
    }
    else {
      echo('<h1>Twoje zamówienia</h1><br><br><img src="img/robo_paka.png">');
      foreach($result as $row) {
        echo('<table><tr><td style="border: 2px solid #ccc;" width="30%"><br>Zamówienie nr: '.$row['basket_id'].'</td><td style="border: 2px solid #ccc;"> Status: '.$row['sended'].'</td></tr>
              <tr><td style="border: 2px solid #ccc;"><br>Suma: '.number_format($row['order_price_sum'], 2, '.', '').' zł</td><td style="border: 2px solid #ccc;">Forma płatności: '.$row['p_desc'].'</td></tr>
              <tr><td style="border: 2px solid #ccc;"><table width="100%"><tr><td>Przesyłka:   </td><td><img src="img/couriers/'.$row['logo'].'" title="'.$row['k_desc'].'" style="width: 100%; float: left;"></td></tr></table></td><td style="border: 2px solid #ccc;">Zakończono: '.$row['completed_at'].'</td></tr></table><table><tr><td><br><br></td></tr></table>');
      }
    }

  }
  elseif (!isset($_SESSION['logged'])) {
      header('Location: logout.php charset=utf-8');
  }
}

function registered() {
    echo('Witaj! Miło nam Ciebie gościć. Zaloguj się na swoje konto, aby aktywować usługę<img src="img/robo_hello.png">');
}

function randon_passwd() {
    $char = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!.?*&^%$#';
    $new_passwd = array();
    $arr_len = strlen($char) - 1;
    for ($i = 0; $i < 10; $i++) {
        $n = rand(0, $arr_len);
        $new_passwd[] = $char[$n];
    }
    return implode($new_passwd);
}

function gen_passwd() {
  if (isset($_POST['gen_passwd']) && filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
    $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
    $user_email = $_POST['email'];
    $generated_passwd = randon_passwd();
    $hash_passwd = password_hash($generated_passwd, PASSWORD_DEFAULT);
    mysqli_query($conn, "SELECT generate_passwd('".$user_email."', '".$hash_passwd."', '".$generated_passwd."')");
    mysqli_close($conn);
    echo("<table border=0 width=40%><tr><td width=17% colspan='2' align='center'>Hasło zostało wysłane na podany adres e-mail<br>
    Jeżeli nie widzisz otrzymanej od nas wiadomości e-mail sprawdź swój folder SPAM<br>
    Za chwilkę nastąpi przekierowanie na stronę główną<br>
    </td></tr><script type='text/javascript'>auto_redirect();</script></td></tr></table>");
  }
  else {
      echo("<table border=0 width=40%><tr><td width=17% colspan='2'>");
      if (isset($_POST['email']) && !filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
          echo("<div id='error_login'>Nie podano prawidłowego adresu e-mail, spróbuj ponownie</div>");
      }
      echo('<br><br></td></tr></table><table border=0 width=35%><tr><td align="center">
      <form method="POST" action="generate_password.php">
      <b>Wpisz swój adres e-mail<br> Jeżeli znajdziemy Twój adres e-mail wyślemy nowe hasło na podany poniżej nowe hasło:<br><br></b></td></tr>
      <tr><td align="center"><input type="email" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" name="email" required><br>
      <input type="submit" value="Wyślij hasło" name="gen_passwd">
      </form><br></td></tr>
      <tr><td align="center"><br><br><a href="index.php">Powrót do strony głównej</a></td></tr></table>');
  }
}

function add_box($prod_id) {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  if(!isset($_SESSION['box_items'])){
    $_SESSION['box_items'] = array();
  }
  array_push($_SESSION['box_items'], $prod_id);
  $result = mysqli_query($conn, "SELECT add_box('".$prod_id."','".$quantity."'')");
  header('Location: sklep.php');
}
function remove_box($prod_id) {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  $i = array_search($prod_id, $_SESSION['box_items']);
  unset($_SESSION['box_items'][$i]);
  if (sizeof($_SESSION['box_items']) == 0){
    unset($_SESSION['box_items']);
  }
  $result = mysqli_query($conn, "SELECT add_box('".$prod_id."','".$quantity."'')");
  header('Location: sklep.php?card_box=true');

}

function find_product($args) {
    $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
    $conn->set_charset("utf-8");
    if ($args != NULL) {
      mysqli_query($conn, "SET NAMES utf8");
      mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
      mysqli_query($conn, "SET CHARACTER SET utf8");
      echo('<form method="POST" action="generate_password.php">');
      $result = mysqli_query($conn, "SELECT product_id, product_num, prod_name, price, price_old, picture, CASE WHEN quantity<=0 THEN 'brak'
        WHEN quantity between 1 AND 5 THEN 'malo' WHEN quantity between 6 AND 9 THEN 'dostepny' WHEN quantity between 10 AND 14 THEN 'duzo'
        WHEN 15<=quantity THEN 'bardzo' END as quantity, CASE WHEN quantity<=0 THEN 'Brak na magazynie' WHEN quantity between 1 AND 5 THEN 'Pozostało mało sztuk'
        WHEN quantity between 6 AND 9 THEN 'Dostępny' WHEN quantity between 9 AND 14 THEN 'Dużo w asortymencie' WHEN 15<=quantity THEN 'Bardzo dużo' END as quantity_desc,
        description_short, warehouse_date FROM products WHERE MATCH(prod_name) AGAINST('".$args."')");
        if (mysqli_num_rows($result) == 0) {
          echo('<h1> Wyniki wyszukiwania:</h1><br><br>
            Niestety nie znaleźliśmy nic w wynikach wyszukiwania z wykorzystaniem "'.$args.'"
                <img src="img/robo_not_found.png">');
        }
        else {
          echo('<table id="shop_table">');
          foreach($result as $row) {
            echo('<tr><td width=40% style="padding-bottom:30px"><a href="sklep.php?product='.$row['product_num'].'"><img src="img/products/'.$row['picture'].'"></a></td><td><br><br><h4><a href="sklep.php?product='.$row['product_num'].'">'.$row['prod_name']."</a></h4>".$row['description_short'].
                  '<br><div id="item_ilosc"><img src="img/items_'.$row['quantity'].'.png" alt="'.$row['quantity_desc'].'" title="'.$row['quantity_desc'].'"></div>');
            if ($row['price_old'] != NULL) {
              echo('<div id="old_price">'.$row['price_old'].'   </div>');
            }
            echo('<div id="price_item">'.$row['price'].'zł<br></div>');
            if ($row['warehouse_date'] === NULL) {
              echo('<div id="item_ilosc"><form name="add_box'.$row['product_id'].'" method="post" action="login.php?add_box='.$row['product_num'].'"><input type="hidden" id="prod_id" value="'.$row['product_num'].'"/><span class="butn" onclick="add_box'.$row['product_id'].'.submit()">Do koszyka</span></form></div>');
            }
            else {
              $date = date_create($row['warehouse_date']);
              echo('<h5>Przewidywany termin dostawy: '.date_format($date, 'Y-m-d').'</h5>');
            }
            echo('</td></tr>');
          }
          echo("</table>");
      }

    }
    else {
      mysqli_query($conn, "SET NAMES utf8");
      mysqli_query($conn, "SET CHARACTER SET utf8");
      mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
      $result = mysqli_query($conn, "SELECT product_id, product_num, prod_name, price, price_old, picture, CASE WHEN quantity<=0 THEN 'brak'
        WHEN quantity between 1 AND 5 THEN 'malo' WHEN quantity between 6 AND 9 THEN 'dostepny' WHEN quantity between 10 AND 14 THEN 'duzo'
        WHEN 15<=quantity THEN 'bardzo' END as quantity, CASE WHEN quantity<=0 THEN 'Brak na magazynie' WHEN quantity between 1 AND 5 THEN 'Pozostało mało sztuk'
        WHEN quantity between 6 AND 9 THEN 'Dostępny' WHEN quantity between 9 AND 14 THEN 'Dużo w asortymencie' WHEN 15<=quantity THEN 'Bardzo dużo' END as quantity_desc,
        description_short, warehouse_date FROM products");
      echo('<table id="shop_table">');
      foreach($result as $row) {
        echo('<tr><td width=40% style="padding-bottom:30px"><a href="sklep.php?product='.$row['product_num'].'"><img src="img/products/'.$row['picture'].'"></a></td><td><br><br><h4><a href="sklep.php?product='.$row['product_num'].'">'.$row['prod_name']."</a></h4>".$row['description_short'].
              '<br><div id="item_ilosc"><img src="img/items_'.$row['quantity'].'.png" alt="'.$row['quantity_desc'].'" title="'.$row['quantity_desc'].'"></div>');
        if ($row['price_old'] != NULL) {
          echo('<div id="old_price">'.$row['price_old'].'   </div>');
        }
        echo('<div id="price_item">'.$row['price'].'zł<br></div>');
        if ($row['warehouse_date'] === NULL) {
          echo('<div id="item_ilosc"><form name="add_box'.$row['product_id'].'" method="post" action="login.php?add_box='.$row['product_num'].'"><input type="hidden" id="prod_id" value="'.$row['product_num'].'"/><span class="butn" onclick="add_box'.$row['product_id'].'.submit()">Do koszyka</span></form></div>');
        }
        else {
          $date = date_create($row['warehouse_date']);
          echo('<h5>Przewidywany termin dostawy: '.date_format($date, 'Y-m-d').'</h5>');
        }
        echo('</td></tr>');
      }
      echo("</table>");
    }
    mysqli_close($conn);
}

function render_product($args) {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  $result = mysqli_query($conn, "SELECT product_id, product_num, prod_name, price, price_old, picture, CASE WHEN quantity<=0 THEN 'brak'
    WHEN quantity between 1 AND 5 THEN 'malo' WHEN quantity between 6 AND 9 THEN 'dostepny' WHEN quantity between 10 AND 14 THEN 'duzo'
    WHEN 15<=quantity THEN 'bardzo' END as quantity, CASE WHEN quantity<=0 THEN 'Brak na magazynie' WHEN quantity between 1 AND 5 THEN 'Pozostało mało sztuk'
    WHEN quantity between 6 AND 9 THEN 'Dostępny' WHEN quantity between 9 AND 14 THEN 'Dużo w asortymencie' WHEN 15<=quantity THEN 'Bardzo dużo' END as quantity_desc,
    description_short, description_long, warehouse_date FROM products WHERE product_num=".$args);
  if (mysqli_num_rows($result) == 0) {
      echo('<h1> Wyniki wyszukiwania:</h1><br><br>
        Niestety nie znaleźliśmy wybranego przedmiotu
            <img src="img/robo_not_found.png">');
  }
  else {
    $row = $result->fetch_assoc();
    echo('<table id="shop_table"><tr><td width=40%><a href="sklep.php?product='.$row['product_num'].'"><img src="img/products/'.$row['picture'].'"></a></td><td><h1><a href="sklep.php?product='.$row['product_num'].'">'.$row['prod_name']."</a></h1><br><br>".$row['description_short'].
          '<br><div id="item_ilosc"><img src="img/items_'.$row['quantity'].'.png" alt="'.$row['quantity_desc'].'" title="'.$row['quantity_desc'].'"></div>');
    if ($row['price_old'] != NULL) {
      echo('<div id="item_ilosc" style="color: #444; text-decoration: line-through; font-size: 16px;">'.$row['price_old'].'   </style></div>');
    }
    echo('<div id="item_ilosc" style="color: #f48b15; font-weight: bold; font-size: 24px;">'.$row['price'].'zł</style><br></div>');
    if ($row['warehouse_date'] === NULL) {
      echo('<div id="price_item"><form name="add_box" method="post" action="login.php?add_box='.$row['product_num'].'"><input type="hidden" id="prod_id" value="'.$row['product_num'].'"/><span class="butn" onclick="add_box.submit()">Do koszyka</span></form></div>');
    }
    else {
      $date = date_create($row['warehouse_date']);
      echo('<h5>Przewidywany termin dostawy: '.date_format($date, 'Y-m-d').'</h5>');
    }
    echo('</td></tr></table><br>'.$row['description_long']);
  }
  mysqli_close($conn);
}

function find_article($args) {
  $conn = mysqli_connect("localhost","root","fhbwyg23q1","elektronik_arts");
  $conn->set_charset("utf-8");
  mysqli_query($conn, "SET NAMES utf8");
  mysqli_query($conn, "SET CHARACTER SET utf8");
  mysqli_query($conn, "SET collation_connection = utf8_polish_ci");
  if($args != NULL) {
    $result = mysqli_query($conn, "SELECT article_id, article_desc, article_num, desc_short, desc_long, picture FROM articles WHERE article_num=".$args);
    if (mysqli_num_rows($result) == 0) {
      echo('<h1> Wyniki wyszukiwania:</h1><br><br>
        Niestety nie znaleźliśmy wybranego atykułu
            <img src="img/robo_not_found.png">');
    }
    else {
      foreach($result as $row) {
        echo('<table id="shop_table"><tr><td width=40%><a href="projekty.php?article='.$row['article_num'].'"><img src="img/articles/'.$row['picture'].'"></a></td><td><h1><a href="projekty.php?article='.$row['article_num'].'">'.$row['article_desc']."</a></h1><br><br>".$row['desc_short'].'<br></div></table>'.$row['desc_long']);
      }
    }
  }
  else {
    $result = mysqli_query($conn, "SELECT article_id, article_desc, article_num, desc_short, desc_long, picture FROM articles ORDER BY article_id DESC");
    echo('<h1>Nasze Inspiracje</h1><br><br><table id="shop_table">');
    foreach($result as $row) {
      echo('<tr><td width=40%><a href="projekty.php?article='.$row['article_num'].'"><img src="img/articles/'.$row['picture'].'"></a></td><td><h1><a href="projekty.php?article='.$row['article_num'].'">'.$row['article_desc']."</a></h1><br><br>".$row['desc_short'].'<br></div>');
    }
    echo('</table>');
  }
  mysqli_close($conn);
}

?>
