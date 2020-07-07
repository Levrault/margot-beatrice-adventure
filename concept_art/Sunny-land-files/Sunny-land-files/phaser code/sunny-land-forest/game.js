/*
 * SUNNY LAND FOREST Demo Code
 * @copyright    2017 Ansimuz
 * @license      {@link https://opensource.org/licenses/MIT | MIT License}
 * Get free assets and code at: www.pixelgameart.org
 * */

var game;
var player;
var background;
var middleground;
var gameWidth = 320;
var gameHeight = 240;
var globalMap;
var enemies_group;
var carrots_group;
var stars_group;
var chests_group;
var loot_group;
var hurtFlag = false;
var audioFlag = true;
var score = 0;

window.onload = function () {

    game = new Phaser.Game(gameWidth, gameHeight, Phaser.AUTO, "");
    game.state.add('Boot', boot);
    game.state.add('Preload', preload);
    game.state.add('TitleScreen', titleScreen);
    game.state.add('PlayGame', playGame);
    game.state.add('GameOver', gameOver);
    //
    game.state.start("Boot");
}

var boot = function (game) {
};
boot.prototype = {
    preload: function () {
        this.game.load.image("loading", "assets/sprites/loading.png");
    },
    create: function () {

        game.scale.pageAlignHorizontally = true;
        game.scale.pageAlignVertically = true;
        game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
        game.renderer.renderSession.roundPixels = true; // blurring off
        this.game.state.start("Preload");
    }
}

var preload = function (game) {
};
preload.prototype = {

    preload: function () {
        var loadingBar = this.add.sprite(game.width / 2, game.height / 2, "loading");
        loadingBar.anchor.setTo(0.5);
        game.load.setPreloadSprite(loadingBar);
        // load title screen
        game.load.image("title", "assets/sprites/title-screen.png");
        game.load.image("enter", "assets/sprites/press-enter-text.png");
        game.load.image("credits", "assets/sprites/credits-text.png");
        game.load.image("instructions", "assets/sprites/instructions.png");
        game.load.image("gameover", "assets/sprites/game-over.png");
        // environment
        game.load.image("background", "assets/environment/background.png");
        game.load.image("middleground", "assets/environment/middleground.png");
        // tileset
        game.load.image("tileset", "assets/environment/tileset.png");
        game.load.image("collisions", "assets/environment/collisions.png");
        game.load.tilemap("map", "assets/maps/map.json", null, Phaser.Tilemap.TILED_JSON);
        // atlas
        game.load.atlasJSONArray("atlas", "assets/atlas/atlas.png", "assets/atlas/atlas.json");
        game.load.atlasJSONArray("atlas-props", "assets/atlas/atlas-props.png", "assets/atlas/atlas-props.json");
        // audio
        game.load.audio("music", ["assets/sound/enchanted_forest_loop.ogg", "assets/sound/enchanted_forest.mp3"]);
        game.load.audio("carrot", ["assets/sound/carrot.ogg", "assets/sound/carrot.mp3"]);
        game.load.audio("enemy-death", ["assets/sound/enemy-death.ogg", "assets/sound/enemy-death.mp3"]);
        game.load.audio("hurt", ["assets/sound/hurt.ogg", "assets/sound/hurt.mp3"]);
        game.load.audio("jump", ["assets/sound/jump.ogg", "assets/sound/jump.mp3"]);
        game.load.audio("star", ["assets/sound/star.ogg", "assets/sound/star.mp3"]);
        game.load.audio("chest", ["assets/sound/chest.ogg", "assets/sound/chest.mp3"]);

    },
    create: function () {
        this.game.state.start("TitleScreen");
    }

}

var titleScreen = function (game) {
};
titleScreen.prototype = {
    create: function () {
        background = game.add.tileSprite(0, 0, gameWidth, gameHeight, "background");
        middleground = game.add.tileSprite(0, 0, gameWidth, gameHeight, "middleground");
        this.title = game.add.image(game.width / 2, 130, "title");
        this.title.anchor.setTo(0.5, 1);
        //
        this.pressEnter = game.add.image(game.width / 2, game.height - 35, "enter");
        this.pressEnter.anchor.setTo(0.5);
        //
        var startKey = game.input.keyboard.addKey(Phaser.Keyboard.ENTER);
        startKey.onDown.add(this.startGame, this);
        this.state = 1;
        //
        game.time.events.loop(700, this.blinkText, this);
        //
        var credits = game.add.image(game.width / 2, game.height - 15, "credits");
        credits.anchor.setTo(0.5);
    },
    startGame: function () {
        if (this.state == 1) {
            this.state = 2;
            this.title2 = game.add.image(game.width / 2, game.height / 2, 'instructions');
            this.title2.anchor.setTo(0.5);
            this.title.destroy();
        } else {
            this.game.state.start('PlayGame');
        }
    },
    blinkText: function () {
        if (this.pressEnter.alpha) {
            this.pressEnter.alpha = 0;
        } else {
            this.pressEnter.alpha = 1;
        }
    },
    update: function () {
        background.tilePosition.x -= 0.25;
        middleground.tilePosition.x -= 0.4;
    }
}

var gameOver = function (game) {
};
gameOver.prototype = {
    create: function () {

        background = game.add.tileSprite(0, 0, gameWidth, gameHeight, "background");
        middleground = game.add.tileSprite(0, 0, gameWidth, gameHeight, "middleground");
        this.title = game.add.image(game.width / 2, game.height / 2, 'gameover');
        this.title.anchor.setTo(0.5);
        //
        this.pressEnter = game.add.image(game.width / 2, game.height - 35, "enter");
        this.pressEnter.anchor.setTo(0.5);
        //
        var startKey = game.input.keyboard.addKey(Phaser.Keyboard.ENTER);
        startKey.onDown.add(this.startGame, this);
        //
        game.time.events.loop(700, this.blinkText, this);
        //
        var credits = game.add.image(game.width / 2, game.height - 15, "credits");
        credits.anchor.setTo(0.5);
    },
    startGame: function () {

        this.game.state.start('PlayGame');
    },
    blinkText: function () {
        if (this.pressEnter.alpha) {
            this.pressEnter.alpha = 0;
        } else {
            this.pressEnter.alpha = 1;
        }
    },
    update: function () {
        background.tilePosition.x -= 0.25;
        middleground.tilePosition.x -= 0.4;
    }
}

var playGame = function (game) {
};
playGame.prototype = {
    create: function () {
        this.createBg();

        this.createTileMap(1);
        this.decorWorld();

        this.createPlayer(2, 9);

        this.createGroups();
        this.populate();
        this.decorWorldFront();
        this.createCarrots();
        this.camFollow();
        this.bindKeys();
        this.createStars();
        this.startMusic();
        this.addAudios();
        this.createHud();

    },

    createHud: function () {

        this.hud = game.add.sprite(10, 10, "atlas", "hud/hud-4");
        this.hud.fixedToCamera = true;

        this.scoreLabel = game.add.text(10 + 47, 11, "0", {font: "8px VT323", fill: "#ffffff"});
        this.scoreLabel.fixedToCamera = true;
        score = 0;

    },
    startMusic: function () {
        if (!audioFlag) {
            return
        }

        this.music = game.add.audio("music");
        this.music.loop = true;

        this.music.play();

    },
    addAudios: function () {
        this.audioCarrot = game.add.audio("carrot");
        this.audioEnemyDeath = game.add.audio("enemy-death");
        this.audioHurt = game.add.audio("hurt");
        this.audioJump = game.add.audio("jump");
        this.audioStar = game.add.audio("star");
        this.audioChest = game.add.audio("chest");
    },
    createCarrots: function () {
        // create groups
        carrots_group = game.add.group();
        carrots_group.enableBody = true;

        globalMap.createFromObjects("Object Layer", 6, "atlas", 0, true, false, carrots_group);

        // add animation to all items
        carrots_group.callAll('animations.add', 'animations', 'spin', ['carrot/carrot-1', 'carrot/carrot-2', 'carrot/carrot-3', 'carrot/carrot-4'], 7, true);
        carrots_group.callAll('animations.play', 'animations', 'spin');

    },
    createStars: function () {
        // create groups
        stars_group = game.add.group();
        stars_group.enableBody = true;

        globalMap.createFromObjects("Object Layer", 7, "atlas", 0, true, false, stars_group);
        // add animations
        stars_group.callAll("animations.add", "animations", "spin-star", ["star/star-1", "star/star-2", "star/star-3", "star/star-4", , "star/star-5", , "star/star-6"], 10, true);
        stars_group.callAll("animations.play", "animations", "spin-star");
    },

    bindKeys: function () {
        this.wasd = {
            jump: game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR),
            left: game.input.keyboard.addKey(Phaser.Keyboard.LEFT),
            right: game.input.keyboard.addKey(Phaser.Keyboard.RIGHT),
            duck: game.input.keyboard.addKey(Phaser.Keyboard.DOWN),
            up: game.input.keyboard.addKey(Phaser.Keyboard.UP)
        }
        game.input.keyboard.addKeyCapture(
            [Phaser.Keyboard.SPACEBAR,
                Phaser.Keyboard.LEFT,
                Phaser.Keyboard.RIGHT,
                Phaser.Keyboard.DOWN,
                Phaser.Keyboard.UP]
        );
    },
    createBg: function () {
        background = game.add.tileSprite(0, 0, gameWidth, gameHeight, "background");
        middleground = game.add.tileSprite(0, 0, gameWidth, gameHeight, "middleground");
        background.fixedToCamera = true;
        middleground.fixedToCamera = true;
    },
    createTileMap: function (levelNum) {
        if (levelNum == 1) {
            levelNum = "";
        }
        //tilemap
        globalMap = game.add.tilemap("map" + levelNum);
        globalMap.addTilesetImage("collisions");
        globalMap.addTilesetImage("tileset");

        this.layer_collisions = globalMap.createLayer("Collisions Layer");
        //this.layer_collisions.visible = false;

        this.layer = globalMap.createLayer("Main Layer");

        // collisions
        globalMap.setCollision([1]);
        this.setTopCollisionTiles(2);

        // specific tiles for enemies
        globalMap.setTileIndexCallback(3, this.enemyCollide, this);
        globalMap.setTileIndexCallback(4, this.triggerLadder, this);
        globalMap.setTileIndexCallback(5, this.killZone, this);
        globalMap.setTileIndexCallback(8, this.exitZone, this);

        this.layer.resizeWorld();
        this.layer_collisions.resizeWorld();
        this.layer_collisions.visible = false;
        // this.layer_collisions.debug = true;

    },
    enemyCollide: function (obj) {
        if (obj.kind == "slug") {
            // enemy.y = 0;
            obj.turnAround();
        }

    },

    killZone: function (obj) {
        if (obj.kind == "player") {
            obj.death();

        }
    },

    exitZone: function (obj) {
        if (obj.kind == "player") {
            this.music.stop();
            this.game.state.start("GameOver");

        }
    },

    triggerLadder: function (obj) {
        if (obj.kind == "player" && this.wasd.up.isDown) {
            obj.onLadder = true;
        }
    },

    setTopCollisionTiles: function (tileIndex) {
        var x, y, tile;
        for (x = 0; x < globalMap.width; x++) {
            for (y = 1; y < globalMap.height; y++) {
                tile = globalMap.getTile(x, y);
                if (tile !== null) {
                    if (tile.index == tileIndex) {
                        tile.setCollision(false, false, true, false);
                    }

                }
            }
        }
    },
    decorWorld: function () {
        this.addProp(1, 0.2, 'tree');
        this.addProp(11, 10.3, 'mushroom-red');
        this.addProp(3, 0, 'vine');
        this.addProp(25, 0, 'vine');
        this.addProp(17, 11, 'mushroom-brown');
        this.addProp(120, 0.2, 'tree');
        this.addProp(146, 2.7, 'house');

        this.addProp(130, 0, 'vine');
        this.addProp(136, 0, 'vine');

        this.addProp(144, 11.3, 'mushroom-red');

        this.addProp(140, 11.3, 'mushroom-brown');

    },

    decorWorldFront: function () {

        this.addProp(16, 12.7, 'rock');
        this.addProp(2, 12, 'plant');
        this.addProp(23, 12, 'plant');
        this.addProp(53, 11.7, 'rock');

        this.addProp(150, 12, 'plant');
        this.addProp(152, 12, 'plant');
        this.addProp(143, 12, 'plant');
        this.addProp(119, 12, 'plant');
        this.addProp(122, 12.5, 'rock');
    },

    addProp: function (x, y, item) {
        game.add.image(x * 16, y * 16, 'atlas-props', item);
    },
    createGroups: function () {
        enemies_group = game.add.group();
        enemies_group.enableBody = true;
        //
        chests_group = game.add.group();
        chests_group.enableBody = true;
        //
        loot_group = game.add.group();
        loot_group.enableBody = true;
    },
    populate: function () {
        // this.spawnSlug(5, 10);
        this.spawnSlug(12, 10);
        this.spawnSlug(18, 12);
        this.spawnSlug(31, 2);
        this.spawnBee(33, 10, 20);
        this.spawnPlant(42, 10);
        this.spawnBee(48, 10, 30, true);
        this.spawnBee(60, 10, 30);
        this.spawnPlant(64, 5);

        this.spawnChest(71, 10);
        this.spawnChest(32, 21);

        this.spawnSlug(93, 21);
        this.spawnPlant(101, 20);
        this.spawnBee(111, 9, 30, true);
        this.spawnPlant(100, 7);

        this.spawnSlug(73, 21);
        this.spawnSlug(83, 21);

        this.spawnSlug(129, 11);
        this.spawnSlug(132, 11);

        this.spawnBee(142, 9, 30, false);

    },
    spawnSlug: function (x, y) {
        var temp = new Slug(game, x, y);
        game.add.existing(temp);
        enemies_group.add(temp);
    },
    spawnBee: function (x, y, distance, horizontal) {
        var temp = new Bee(game, x, y, distance, horizontal);
        game.add.existing(temp);
        enemies_group.add(temp);
    },
    spawnPlant: function (x, y) {
        var temp = new Plant(game, x, y);
        game.add.existing(temp);
        enemies_group.add(temp);
    },
    spawnChest: function (x, y) {
        var temp = new Chest(game, x, y);
        game.add.existing(temp);
        chests_group.add(temp);
    },
    createPlayer: function (x, y) {
        var temp = new Player(game, x, y);
        game.add.existing(temp);
    },
    camFollow: function () {
        game.camera.follow(player, Phaser.Camera.FOLLOW_PLATFORMER);
    },
    update: function () {



        // physics
        game.physics.arcade.collide(enemies_group, this.layer_collisions);
        game.physics.arcade.collide(chests_group, this.layer_collisions);
        game.physics.arcade.collide(loot_group, this.layer_collisions);

        if (player.alive) {
            //physics
            game.physics.arcade.collide(player, this.layer_collisions);
            //overlaps
            game.physics.arcade.overlap(player, enemies_group, this.checkAgainstEnemies, null, this);
            game.physics.arcade.overlap(player, carrots_group, this.collectCarrot, null, this);
            game.physics.arcade.overlap(player, stars_group, this.collectStar, null, this);
            game.physics.arcade.overlap(player, chests_group, this.checkAgainstChests, null, this);
            game.physics.arcade.overlap(player, loot_group, this.collectLoot, null, this);
        }

        //
        this.movePlayer();
        this.parallaxBg();
        this.hurtManager();
        this.deathReset();

        this.updateHealthHud();
        // this.debugGame();

    },
    deathReset: function () {
        if (player.y > 16 * 60) {
           // player.reset();
            this.music.stop();
            this.game.state.start("GameOver");
        }
    },
    collectCarrot: function (player, item) {
        item.kill();
        this.audioCarrot.play();
        player.health++;
        if (player.health > 3) {
            player.health = 3;
        }
    },
    collectStar: function (player, item) {
        this.increaseScore();
        item.kill();
        this.audioStar.play();

    },
    increaseScore: function () {
        score++;
        this.scoreLabel.text = score;
    },
    collectLoot: function (player, item) {
        if (item.able) {
            item.kill();
            this.audioStar.play();
            this.increaseScore();
        }

    },
    hurtPlayer: function () {

        if (hurtFlag) {
            return;
        }
        hurtFlag = true;
        this.game.time.reset();

        player.animations.play("hurt");
        player.y -= 5;

        player.body.velocity.y = -150;
        player.body.velocity.x = (player.scale.x == 1) ? -22 : 22;
        player.health--;

        this.audioHurt.play();
        if (player.health < 1) {
            player.death();

        }
    },
    hurtManager: function () {
        if (hurtFlag && this.game.time.totalElapsedSeconds() > 0.3) {
            hurtFlag = false;
        }
    },
    updateHealthHud: function () {
        switch (player.health) {
            case 3:
                this.hud.frameName = "hud/hud-4";
                break;
            case 2:
                this.hud.frameName = "hud/hud-3";
                break;
            case 1:
                this.hud.frameName = "hud/hud-2";
                break;
            case 0:
                this.hud.frameName = "hud/hud-1";
                break;
        }
    },

    checkAgainstEnemies: function (player, enemy) {

        if ((player.y + player.body.height * 0.5 < enemy.y ) && player.body.velocity.y > 0) {

            enemy.kill();
            enemy.destroy();
            this.audioEnemyDeath.play();
            this.spawnEnemyDeath(enemy.x, enemy.y);
            player.body.velocity.y = -300;
        } else {
            this.hurtPlayer();
        }
    },
    checkAgainstChests: function (player, chest) {
        if ((player.y + player.body.height * 0.5 < chest.y ) && player.body.velocity.y > 0 && !chest.opened) {
            player.body.velocity.y = -100;
            chest.open();
            this.audioChest.play();
        }
    },
    spawnEnemyDeath: function (x, y) {
        var temp = new EnemyDeath(game, x, y);
        game.add.existing(temp);
    },
    parallaxBg: function () {
        background.tilePosition.x = this.layer.x * -0.2;
        middleground.tilePosition.x = this.layer.x * -0.5;
    },
    movePlayer: function () {

        if (!player.alive) {
            player.animations.play("hurt");
            return;
        }

        if (hurtFlag) {
            player.animations.play("hurt");
            return;
        }

        if (player.onLadder) {
            player.animations.play("climb");

            var vel = 30;
            if (this.wasd.duck.isDown) {
                player.body.velocity.y = vel;
            } else if (this.wasd.up.isDown) {
                player.body.velocity.y = -vel;
            }

            //horizontal

            if (this.wasd.left.isDown) {
                player.body.velocity.x = -vel;

                player.scale.x = -1;
            } else if (this.wasd.right.isDown) {
                player.body.velocity.x = vel;

                player.scale.x = 1;
            } else {
                player.body.velocity.x = 0;

            }

            return;
        }

        if (this.wasd.jump.isDown && player.body.onFloor()) {
            player.body.velocity.y = -200;
            this.audioJump.play();

        }

        var vel = 80;
        if (this.wasd.left.isDown) {
            player.body.velocity.x = -vel;
            this.moveAnimation();
            player.scale.x = -1;
        } else if (this.wasd.right.isDown) {
            player.body.velocity.x = vel;
            this.moveAnimation();
            player.scale.x = 1;
        } else {
            player.body.velocity.x = 0;
            this.stillAnimation();

        }

    },
    moveAnimation: function () {
        if (player.body.velocity.y < 0) {
            player.animations.play("jump");
        } else if (player.body.velocity.y > 0) {
            player.animations.play("fall");
        } else {
            player.animations.play("skip");
        }
    },
    stillAnimation: function () {
        if (player.body.velocity.y < 0) {
            player.animations.play("jump");
        } else if (player.body.velocity.y > 0) {
            player.animations.play("fall");
        } else if (this.wasd.duck.isDown) {
            player.animations.play("duck");
        } else {
            player.animations.play("idle");
        }
    },
    debugGame: function () {
        //game.debug.spriteInfo(this.player, 30, 30);
        game.debug.body(enemies_group);
        game.debug.body(player);

        enemies_group.forEachAlive(this.renderGroup, this);
        chests_group.forEachAlive(this.renderGroup, this);

    },
    renderGroup: function (member) {
        game.debug.body(member);
    }
}

// player

Player = function (game, x, y) {
    x *= 16;
    y *= 16;
    this.initX = x;
    this.initY = y;
    this.health = 3;
    this.onLadder = false;
    Phaser.Sprite.call(this, game, x, y, "atlas", "player-idle/player-idle-1");
    this.anchor.setTo(0.5);
    game.physics.arcade.enable(this);
    this.body.gravity.y = 300;
    this.body.setSize(12, 26, 10, 6);
    //add animations
    var animVel = 12;
    this.animations.add('idle', Phaser.Animation.generateFrameNames('player-idle/player-idle-', 1, 9, '', 0), animVel, true);
    this.animations.add('skip', Phaser.Animation.generateFrameNames('player-skip/player-skip-', 1, 8, '', 0), animVel, true);
    this.animations.add('jump', Phaser.Animation.generateFrameNames('player-jump/player-jump-', 1, 4, '', 0), animVel, true);
    this.animations.add('fall', Phaser.Animation.generateFrameNames('player-fall/player-fall-', 1, 4, '', 0), animVel, true);
    this.animations.add('duck', Phaser.Animation.generateFrameNames('player-duck/player-duck-', 1, 4, '', 0), animVel, true);
    this.animations.add('hurt', Phaser.Animation.generateFrameNames('player-hurt/player-hurt-', 1, 2, '', 0), animVel, true);
    this.animations.add('climb', Phaser.Animation.generateFrameNames('player-climb/player-climb-', 1, 4, '', 0), animVel, true);
    this.animations.play("idle");
    this.kind = "player";
    player = this;

}
Player.prototype = Object.create(Phaser.Sprite.prototype);
Player.prototype.constructor = Player;
Player.prototype.update = function () {
    if (this.onLadder) {
        this.body.gravity.y = 0;
    } else {
        this.body.gravity.y = 300;
    }
    this.onLadder = false;

}
Player.prototype.reset = function () {
    this.x = this.initX;
    this.y = this.initY;
    this.health = 3;
    this.body.velocity.y = 0;
    this.alive = true;
    this.animations.play('idle');
    hurtFlag = false;

}
Player.prototype.death = function () {
    this.alive = false;
    this.body.velocity.x = 0;
    this.body.velocity.y = -400;
}

// slug

Slug = function (game, x, y) {
    x *= 16;
    y *= 16;
    Phaser.Sprite.call(this, game, x, y, "atlas", "slug/slug-1");
    this.animations.add('crawl', Phaser.Animation.generateFrameNames('slug/slug-', 1, 4, '', 0), 10, true);
    this.animations.play("crawl");
    this.anchor.setTo(0.5);
    game.physics.arcade.enable(this);
    this.body.setSize(20, 11, 7, 10);
    this.body.gravity.y = 500;
    this.speed = 40;
    this.body.velocity.x = this.speed;
    this.body.bounce.x = 1;
    this.kind = "slug";

}
Slug.prototype = Object.create(Phaser.Sprite.prototype);
Slug.prototype.constructor = Slug;
Slug.prototype.update = function () {
    if (this.body.velocity.x < 0) {
        this.scale.x = 1;

    } else {
        this.scale.x = -1;

    }
}
Slug.prototype.turnAround = function () {
    if (this.body.velocity.x > 0) {
        this.body.velocity.x = -this.speed;
        this.x -= 5;
    } else {
        this.body.velocity.x = this.speed;
        this.x += 5;
    }

}

// bee

Bee = function (game, x, y, distance, horizontal) {
    x *= 16;
    y *= 16;

    Phaser.Sprite.call(this, game, x, y, "atlas", "bee/bee-1");
    this.animations.add('fly', Phaser.Animation.generateFrameNames('bee/bee-', 1, 8, '', 0), 15, true);
    this.animations.play("fly");
    this.anchor.setTo(0.5);
    game.physics.arcade.enable(this);
    this.body.setSize(15, 18, 11, 13);
    this.initX = this.x;
    this.initY = this.y;
    this.distance = distance;
    this.speed = 40;
    this.horizontal = horizontal;
    if (this.horizontal) {
        this.body.velocity.x = this.speed;
        this.body.velocity.y = 0;
    } else {
        this.body.velocity.x = 0;
        this.body.velocity.y = this.speed;
    }

}
Bee.prototype = Object.create(Phaser.Sprite.prototype);
Bee.prototype.constructor = Bee;
Bee.prototype.update = function () {
    if (this.horizontal) {
        this.horizontalMove();
    } else {
        this.verticalMove();
    }

}
Bee.prototype.verticalMove = function () {
    if (this.body.velocity.y > 0 && this.y > this.initY + this.distance) {
        this.body.velocity.y = -40;
    } else if (this.body.velocity.y < 0 && this.y < this.initY - this.distance) {
        this.body.velocity.y = 40;
    }
    if (this.x > player.x) {
        this.scale.x = 1;
    } else {
        this.scale.x = -1;
    }
}
Bee.prototype.horizontalMove = function () {
    if (this.body.velocity.x > 0 && this.x > this.initX + this.distance) {
        this.body.velocity.x = -40;
    } else if (this.body.velocity.x < 0 && this.x < this.initX - this.distance) {
        this.body.velocity.x = 40;
    }
    if (this.body.velocity.x < 0) {
        this.scale.x = 1;
    } else {
        this.scale.x = -1;
    }
}

// plant

Plant = function (game, x, y) {
    x *= 16;
    y *= 16;

    Phaser.Sprite.call(this, game, x, y, "atlas", "piranha-plant/piranha-plant-1");
    this.animations.add('idle', Phaser.Animation.generateFrameNames('piranha-plant/piranha-plant-', 1, 5, '', 0), 10, true);
    this.animations.add('attack', Phaser.Animation.generateFrameNames('piranha-plant-attack/piranha-plant-attack-', 1, 4, '', 0), 10, true);
    this.animations.play("idle");
    this.anchor.setTo(0.5);
    game.physics.arcade.enable(this);
    this.body.gravity.y = 500;
    //this.body.setSize(18, 29, 21, 16);
    this.body.setSize(61, 29, 0, 16);
}
Plant.prototype = Object.create(Phaser.Sprite.prototype);
Plant.prototype.constructor = Plant;
Plant.prototype.update = function () {

    if (this.x > player.x) {
        this.scale.x = 1;
    } else {
        this.scale.x = -1;

    }

    var distance = game.physics.arcade.distanceBetween(this, player);

    if (distance < 65) {
        this.animations.play("attack");

    } else {
        this.animations.play("idle");
    }

}

// enemy death

EnemyDeath = function (game, x, y) {
    Phaser.Sprite.call(this, game, x, y, "atlas", "enemy-death/enemy-death-1");
    this.anchor.setTo(0.5);
    var anim = this.animations.add("death", Phaser.Animation.generateFrameNames("enemy-death/enemy-death-", 1, 6, '', 0), 18, false);
    this.animations.play("death");
    anim.onComplete.add(function () {
            this.kill();
        }, this
    );
}

EnemyDeath.prototype = Object.create(Phaser.Sprite.prototype);
EnemyDeath.prototype.constructor = EnemyDeath;

// chest

Chest = function (game, x, y, audioChest) {
    x *= 16;
    y *= 16;
    this.opened = false;
    Phaser.Sprite.call(this, game, x, y, "atlas", "chest/chest-1");
    this.animations.add('open', ["chest/chest-2"], 0, false);

    this.anchor.setTo(0.5);
    game.physics.arcade.enable(this);
    this.body.setSize(19, 12, 9, 13);
    this.body.gravity.y = 500;
    this.kind = "chest";

}
Chest.prototype = Object.create(Phaser.Sprite.prototype);
Chest.prototype.constructor = Slug;
Chest.prototype.open = function () {
    this.opened = true;
    this.animations.play("open");

//spawn stars
    for (var i = 0; i <= 5; i++) {
        var temp = new Star(game, this.x, this.y - 15);
        game.add.existing(temp);
        loot_group.add(temp);
    }

}

// bouncy star

Star = function (game, x, y) {
    this.able = false;
    this.bounceCount = 0;
    Phaser.Sprite.call(this, game, x, y, "atlas", "star/star-1");
    this.animations.add('spin', Phaser.Animation.generateFrameNames('star/star-', 1, 4, '', 0), 10, true);
    this.animations.play("spin");
    this.anchor.setTo(0.5);
    game.physics.arcade.enable(this);

    this.body.velocity.y = game.rnd.realInRange(150, 220);
    this.body.velocity.x = game.rnd.realInRange(-30, 31);
    this.body.drag.set(10);
    this.body.bounce.set(0.8);
    this.body.gravity.y = 500;

    this.kind = "star";

}
Star.prototype = Object.create(Phaser.Sprite.prototype);
Star.prototype.constructor = Star;
Star.prototype.update = function () {

    if (this.body.onFloor()) {
        this.bounceCount++;

    }
    if (this.bounceCount >= 3) {
        this.able = true;
    }
}














