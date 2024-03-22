PVector player1;
PVector player2;
PVector player1Velocity;
PVector player2Velocity;
PVector boss;
PVector bossVelocity;
float playerSpeed = 5;
float bossSpeed = 3;

ArrayList<PVector> bulletsPlayer1;
ArrayList<PVector> bulletsPlayer2;
ArrayList<PVector> bulletsBoss;
float bulletSpeed = 8;

boolean player1Eliminated = false;
boolean player2Eliminated = false;
boolean bossEliminated = false;

void setup() {
  size(800, 400);
  player1 = new PVector(100, height / 2);
  player2 = new PVector(width - 100, height / 2);
  boss = new PVector(width / 2, height / 2);
  player1Velocity = new PVector(0, 0);
  player2Velocity = new PVector(0, 0);
  bossVelocity = PVector.random2D().mult(bossSpeed);
  
  bulletsPlayer1 = new ArrayList<PVector>();
  bulletsPlayer2 = new ArrayList<PVector>();
  bulletsBoss = new ArrayList<PVector>();
}

void draw() {
  background(0);
  
  if (!player1Eliminated) {
    // Tegn spiller 1
    fill(255, 0, 0);
    ellipse(player1.x, player1.y, 30, 30);
  }
  
  if (!player2Eliminated) {
    // Tegn spiller 2
    fill(0, 0, 255);
    ellipse(player2.x, player2.y, 30, 30);
  }
  
  if (!bossEliminated) {
    // Tegn boss
    fill(255, 255, 0);
    ellipse(boss.x, boss.y, 50, 50);
  }
  
  // Tegn projektiler for spiller 1
  fill(255, 0, 0);
  for (int i = bulletsPlayer1.size() - 1; i >= 0; i--) {
    PVector bullet = bulletsPlayer1.get(i);
    ellipse(bullet.x, bullet.y, 10, 10);
    bullet.x += bulletSpeed;
    
    // Tjek kollision med spiller 2
    if (!player2Eliminated && dist(bullet.x, bullet.y, player2.x, player2.y) < 20) {
      player2Eliminated = true;
      bulletsPlayer1.remove(i);
    }
    
    // Tjek kollision med boss
    if (!bossEliminated && dist(bullet.x, bullet.y, boss.x, boss.y) < 30) {
      bossEliminated = true;
      bulletsPlayer1.remove(i);
    }
    
    // Fjern projektilen, når den forlader skærmen
    if (bullet.x > width) {
      bulletsPlayer1.remove(i);
    }
  }
  
  // Tegn projektiler for spiller 2
  fill(0, 0, 255);
  for (int i = bulletsPlayer2.size() - 1; i >= 0; i--) {
    PVector bullet = bulletsPlayer2.get(i);
    ellipse(bullet.x, bullet.y, 10, 10);
    bullet.x -= bulletSpeed;
    
    // Tjek kollision med spiller 1
    if (!player1Eliminated && dist(bullet.x, bullet.y, player1.x, player1.y) < 20) {
      player1Eliminated = true;
      bulletsPlayer2.remove(i);
    }
    
    // Tjek kollision med boss
    if (!bossEliminated && dist(bullet.x, bullet.y, boss.x, boss.y) < 30) {
      bossEliminated = true;
      bulletsPlayer2.remove(i);
    }
    
    // Fjern projektilen, når den forlader skærmen
    if (bullet.x < 0) {
      bulletsPlayer2.remove(i);
    }
  }
  
  // Tegn projektiler fra boss
  fill(255, 255, 0);
  for (int i = bulletsBoss.size() - 1; i >= 0; i--) {
    PVector bullet = bulletsBoss.get(i);
    ellipse(bullet.x, bullet.y, 10, 10);
    bullet.add(bossVelocity);
    
    // Tjek kollision med spiller 1
    if (!player1Eliminated && dist(bullet.x, bullet.y, player1.x, player1.y) < 20) {
      player1Eliminated = true;
      bulletsBoss.remove(i);
    }
    
    // Tjek kollision med spiller 2
    if (!player2Eliminated && dist(bullet.x, bullet.y, player2.x, player2.y) < 20) {
      player2Eliminated = true;
      bulletsBoss.remove(i);
    }
    
    // Fjern projektilen, når den forlader skærmen
    if (bullet.x < 0 || bullet.x > width || bullet.y < 0 || bullet.y > height) {
      bulletsBoss.remove(i);
    }
  }
  
  // Tjek kollision mellem projektiler fra spiller 1 og spiller 2
  for (int i = bulletsPlayer1.size() - 1; i >= 0; i--) {
    PVector bullet1 = bulletsPlayer1.get(i);
    for (int j = bulletsPlayer2.size() - 1; j >= 0; j--) {
      PVector bullet2 = bulletsPlayer2.get(j);
      float distance = dist(bullet1.x, bullet1.y, bullet2.x, bullet2.y);
      if (distance < 10) {
        bulletsPlayer1.remove(i);
        bulletsPlayer2.remove(j);
        break;
      }
    }
  }
  
  // Opdater spillerne
  player1.add(player1Velocity);
  player2.add(player2Velocity);
  
  // Opdater bossens position
  if (!bossEliminated) {
    boss.add(bossVelocity);
    
    // Skift bossens retning, hvis den rammer skærmens kanter
    if (boss.x < 0 || boss.x > width || boss.y < 0 || boss.y > height) {
      bossVelocity = PVector.random2D().mult(bossSpeed);
    }
    
    // Boss skyder med jævne mellemrum
    if (frameCount % 120 == 0) {
      PVector target = PVector.random2D().mult(bossSpeed);
      bulletsBoss.add(new PVector(boss.x, boss.y));
      bossVelocity = target;
    }
  }
  
  // Tjek om spillet er slut
  if (player1Eliminated || player2Eliminated || bossEliminated) {
    fill(255);
    textSize(32);
    if (player1Eliminated && player2Eliminated) {
      text("Uafgjort! Tryk på 'r' for at genstarte", width / 2, height / 2);
    } else if (player1Eliminated) {
      text("Spiller 2 vinder! Tryk på 'r' for at genstarte", width / 2, height / 2);
    } else if (player2Eliminated) {
      text("Spiller 1 vinder! Tryk på 'r' for at genstarte", width / 2, height / 2);
    } else {
      text("Bossen er besejret! Tryk på 'r' for at genstarte", width / 2, height / 2);
    }
  } else {
    // Tegn spilletekst
    fill(255);
    textSize(32);
    text("Player 1", 20, 30);
    text("Player 2", width - 140, 30);
    text("Boss", width / 2 - 30, height - 30);
  }
}

void keyPressed() {
  if (!player1Eliminated) {
    if (key == 'w') {
      player1Velocity.y = -playerSpeed;
    } else if (key == 's') {
      player1Velocity.y = playerSpeed;
    }
    
    if (key == 'a') {
      player1Velocity.x = -playerSpeed;
    } else if (key == 'd') {
      player1Velocity.x = playerSpeed;
    }
    
    // Skyd projektiler for spiller 1
    if (key == ' ' && player1.x < width / 2) {
      bulletsPlayer1.add(new PVector(player1.x + 15, player1.y));
    }
  }
  
  if (!player2Eliminated) {
    if (keyCode == UP) {
      player2Velocity.y = -playerSpeed;
    } else if (keyCode == DOWN) {
      player2Velocity.y = playerSpeed;
    }
    
    if (keyCode == LEFT) {
      player2Velocity.x = -playerSpeed;
    } else if (keyCode == RIGHT) {
      player2Velocity.x = playerSpeed;
    }
    
    // Skyd projektiler for spiller 2
    if (key == CODED && keyCode == SHIFT && player2.x > width / 2) {
      bulletsPlayer2.add(new PVector(player2.x - 15, player2.y));
    }
  }
  
  // Genstart spillet ved at trykke på 'r'
  if (key == 'r' || key == 'R') {
    player1Eliminated = false;
    player2Eliminated = false;
    bossEliminated = false;
    player1 = new PVector(100, height / 2);
    player2 = new PVector(width - 100, height / 2);
    boss = new PVector(width / 2, height / 2);
    bulletsPlayer1.clear();
    bulletsPlayer2.clear();
    bulletsBoss.clear();
  }
}

void keyReleased() {
  if (key == 'w' || key == 's') {
    player1Velocity.y = 0;
  }
  
  if (key == 'a' || key == 'd') {
    player1Velocity.x = 0;
  }
  
  if (keyCode == UP || keyCode == DOWN) {
    player2Velocity.y = 0;
  }
  
  if (keyCode == LEFT || keyCode == RIGHT) {
    player2Velocity.x = 0;
  }
}
