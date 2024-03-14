pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

--variables
function _init()

	levels={
		
		level1={
			level1_y=0,
			y=40,
			countOfEnemies=0,
		},

		level2={
			level2_y=136,
			y=40,

			countOfEnemies=0,
		},

		level3={
			level3_y=136,
			y=40,
			countOfEnemies=0,
		}
	}

	hp={
		sp=64,
		x=0,
		y=0,
		width=2,
		height=2
	}
	
	player={
		hp=3,
		sp=0,

		--level1
		x=8,
		y=32,
		

		w=8,
		h=8,

		dt = 0,
		t = 3,

		random=0,
		immortality_sp=1,
		falling_sp=1,

		level=1,

		weapon=false,

		--direction
        left=false,
		
		dx=0, 
		dy=0,

		acc=1,
		boost=3,
		animation_time=0,

		colide=true,
		movement_platform_down=false,
		onPlatform=false,

		immortality=false,

		running=false,
		falling=false,
		jumping=false,
		sliding=false,
		landed=false,
 	}

 	weapon={
		sp=208,
		x=45,
		y=56,
		
		animation_time=0,
		animation_wait=0.8
	}

	water={
		sp=192,
		x1=8 ,
		y1=104,
		x12=160,
		x2=8 ,
		y2=112,
		y3=120,
		y4=128,

		animation_time=0,
		animation_wait=0.2
	}

	ufo={
		sp=143,
		x=1025,
		y=8,
		w=8,
		h=8,

		laser={
			sp1=158,
			sp2=174,
			y=16,
		},

		position_x=20,
		min_x=false,
		moving=false,
		teleport=false,
	
		animation_time=0,
		animation_wait=0.1
	}

	bullets={	
		-- limit=999,
		limit=40,
		sp=66,
		randomNumberX={120, 234, 400, 550, 736, 890}
	}

	bullets_left={}
	bullets_right={}
	
	enemy_bombs={}
	enemy_left_bombs={}
	enemy_right_bombs={}

	ammunition={ 
		limit=0,
		limitAmmunitions=6,
	}
	
	enemies={
		collide=false,

		enemy1={
			type=1,
			limit=0,
			limitEnemies=3,
			placesOfX=0,
			EnemyNumberX={120*8,117*8,114*8},
		},

		enemy2={
			type=2,
			limit=0,
			-- limitEnemies=12,
			limitEnemies=12,
			placesOfX=0,
			-- EnemyNumberX={7*8}
			EnemyNumberX={7*8, 20*8, 22*8, 35*8, 
						  46*8, 59*8, 61*8, 74*8, 
						  88*8, 101*8, 103*8, 116*8}
		},

		enemy3={
			type=3,
			limit=0,
			limitEnemies=7,
			placesOfX=0,
			EnemyNumberX={26*8, 31*8, 46*8, 73*8, 
						  80*8, 87*8, 97*8},
			EnemyNumberY={24*8, 24*8, 28*8, 25*8, 24*8, 23*8, 25*8}
		},

		enemy4={
			type=4,
			limit=0,
			limitEnemies=8,
			-- limitEnemies=1,
			placesOfX=0,
			-- EnemyNumberX={21*8}
			EnemyNumberX={21*8, 36*8, 45*8, 60*8, 
						  75*8, 87*8, 102*8, 117*8}
		},

		boss={
			type=5,
			limit=0,
			limitEnemies=1,
			placesOfX=0,
			EnemyNumberX={124*8}
		}
	}
	doors={
		door={
			open=false, 
			opened=false,

			sp1=80,
			sp2=81,
			sp3=96,
			sp4=97,
			sp5=112,
			sp6=113,

			x1=848,
			x2=856,

			y1=176,
			y2=184,
			y3=192,

			w=16,
			h=24,

			animation_time=0,
			animation_wait=0.2
		},

		door2={
			open=false, 
			opened=false,

			sp1=88,
			sp2=89,
			sp3=104,
			sp4=105,
			sp5=120,
			sp6=121,

			x1=872,
			x2=880,

			y1=176,
			y2=184,
			y3=192,

			w=16,
			h=24,

			animation_time=0,
			animation_wait=0.2
		}
	}
	platform={
		sp=75,
		x1=488,
		x2=496,
		x3=503,
		w=8,
		h=2,
		min_y=false,
		y_start=176,
		-- y_start=232,
		y_end=232,
		-- y=176,
		y=226,
	}


	--timer
	dt = 0
	t = 120
	t_color = 7 
	switch_t = t
	last = time()
	
	--gravitation
	gravity=0.3

	--friction
	friction=0.1

	--camera
	cam_x=0
	cam_y=0

	--map limits
	map_start_level1=8
	map_start_level2=8
	map_start_level3=864
	map_end=1016

	--gameOver
	gameOver=false

	--start
	start=true

	mod=0

end

-->8
--camera
function simpleCamera()
	cam_x=player.x-64
	-- cam_x=player.x-5
	if player.level==1 then
		cam_y=levels.level1.level1_y
	elseif player.level==2 then
		cam_y=levels.level2.level2_y
	elseif player.level==3 then
		cam_y=levels.level3.level3_y
	end
	if player.level==1 then
		if cam_x<map_start_level1 then
			cam_x=map_start_level1
		end
	elseif player.level==2 then
		if cam_x<map_start_level2 then
			cam_x=map_start_level2
		end
	elseif player.level==3 then
		if cam_x<map_start_level3 then
			cam_x=map_start_level3
		end
	end

	if player.level==1 then
		if cam_x>map_end-128 then
			cam_x=map_end-128
		end
	elseif player.level==2 then
		if cam_x>map_end-272 then
			cam_x=map_end-272
		end
	elseif player.level==3 then
		if cam_x>map_end-128  then
			cam_x=map_end-128 
		end
	end
	camera(cam_x,cam_y)
end

-->8
--add sprite

--add fire sprites
function fire()
	local countBullet=0
	countBullet=count(bullets_left)+count(bullets_right)
	if countBullet <2 then
		local bullet={}
		if player.left then
			bullet={
				sp=66,
				x=player.x-2,
				y=player.y,
				dx=4,
				-- dy=player.y,
				h=3,
				w=8
			}	
			add(bullets_left, bullet)
		elseif player.left==false then
			bullet={
				sp=66,
				x=player.x+2,
				y=player.y,
				dx=4,
				-- dy=player.y,
				h=3,
				w=8
			}
			add(bullets_right, bullet)
		end
	end
end

--add_ammunition_pack_sprite
function draw_ammunition()
	while ammunition.limit<ammunition.limitAmmunitions do
		make_ammunition()
		ammunition.limit+=1
	end
end

--create_ammunition_pack
function make_ammunition()
	for z in all(bullets.randomNumberX) do
		if(z==player.random) then
			del(bullets.randomNumberX, z)
		end
	end
	player.random = rnd(bullets.randomNumberX)
	local ammo={
		sp=240,
		x=player.random,
		y=56,
		h=5,
		w=8,
		animation_time=0,
		animation_wait=0.2
	}
	add(ammunition, ammo)
end

function draw_enemy()
	if player.level==1 then
		draw_enemies(enemies.enemy2)
		draw_enemies(enemies.enemy4)
	elseif player.level==2 then	
		draw_enemies(enemies.enemy3)
	elseif player.level==3 then
		draw_enemies(enemies.boss)
	end
end

function draw_enemies(enemy_type)
	while enemy_type.limit<enemy_type.limitEnemies do 
		//to chyba trzeba naprawic jutro 
		if player.level==1 then
			create_enemies(enemy_type)
			enemy_type.limit+=1
			levels.level1.countOfEnemies+=1
		elseif player.level==2 then
			create_enemies(enemy_type)
			enemy_type.limit+=1
			levels.level2.countOfEnemies+=1
		elseif player.level==3 then
			create_enemies(enemy_type)
			enemy_type.limit+=1
			levels.level3.countOfEnemies+=1
		end
	end
end

--create_enemies
function create_enemies(opponent)
	local y=1
	if opponent.type==3 then
		for z in all(opponent.EnemyNumberX) do
			create_eniemies2(opponent, z, opponent.EnemyNumberY[y])
			del(opponent.EnemyNumberX, z)
			y+=1
		end 
	else
		for z in all(opponent.EnemyNumberX) do
			create_eniemies2(opponent,z)
			del(opponent.EnemyNumberX, z)
		end 
	end
end

--create_enemies2
function create_eniemies2(opponent, numberX, numberY)
	local enemy
	if opponent.type==1 then
		enemy={
			sp=128,
			hp=2,
			x=numberX,
			y=24*8,
			w=8,
			h=8,
			position_x=114*8,
			min_x=false,
			left=true,
			shield=false,

			animation_time=0,
			animation_wait=0.1
		}
	end
	if opponent.type==2 then
		if mod%2==0 then
			enemy={
				sp=144,
				hp=1,
				x=numberX,
				y=32,
				w=8,
				h=8,
				position_x=numberX,
				min_x=false,
				left=true,
				touched=false,
				direction=true,
				shield=false,

				animation_time=0,
				animation_wait=0.1
			}
		else
			enemy={
				sp=144,
				hp=1,
				x=numberX,
				y=32,
				w=8,
				h=8,
				position_x=numberX,
				min_x=true,
				left=false,
				touched=false,
				direction=false,
				shield=false,

				animation_time=0,
				animation_wait=0.1
			}
		end
		mod+=1
	end
	if opponent.type==3 then
		enemy={
			type=3,
			sp=160,
			hp=1,
			x=numberX,
			y=numberY,
			w=8,
			position_x=numberX,
			h=8,
			min_x=false,
			left=false,
			shield=false,

			dt = 0,
			t = 0,
			time=3,
			shot=false,

			animation_time=0,
			animation_wait=0.1
		}
	end
	if opponent.type==4 then
		enemy={
			type=4,
			sp=176,
			hp=1,
			x=numberX,
			y=24,
			w=8,
			h=8,
			position_y=8,
			enemy_start_y=24,
			position_x=numberX,
			min_y=true,
			min_x=true,
			left=false,
			start=true,
			shield=false,

			dt = 0,
			t = 0,
			time=3,
			shot=false,

			animation_time=0,
			animation_wait=0.02
		}
	end	
	if opponent.type==5 then
		enemy={	
			sp=201,
			hp=50,
			hp_max=25,
			x=numberX,
			y=24*8,
			w=8,
			h=8,
			position_x=numberX,
			position_y=24*8,
			min_y=true,
			min_x=true,
			left=false,
			shield=true,

			dt = 0,
			t = 0,
			time=3,

			animation_time=0,
			animation_wait=0.2
		}
	end	
	add(opponent, enemy)	
end

-->8
--enemy_animate_and_AI

--enemy1
function enemy1_animate(enemy)
	if enemy.min_x==false then
		enemy.x+=1
		if enemy.x==enemy.position_x+56 then
			enemy.left=false
			enemy.min_x=true
		end
	elseif enemy.min_x==true then
		enemy.x-=1
		if enemy.x==enemy.position_x then
			enemy.left=true
			enemy.min_x=false
		end
	end 
end

function enemy1_ai()
	for enemy in all(enemies.enemy1) do
		if enemy.hp>0 then
			if time() - enemy.animation_time > enemy.animation_wait then
				enemy.sp+=1
				enemy.animation_time = time()
				if enemy.sp>130 then
					enemy.sp=129
				end
			end
			enemy1_animate(enemy)
		else
			del(enemies.enemy1,enemy)
			monsterCoutner()
		end
		if collide_spr(player, enemy) then	
			if player.immortality==false then
				enemies.collide=true
				player.immortality=true
				lossHp()
			end
			enemies.collide=false
		end
	end
end

--enemy2
function enemy2_aniamte(enemy)
	if enemy.min_x==false and enemy.direction==true then
		enemy.animation_wait=0.1
		enemy.x+=0.5
		if enemy.x==enemy.position_x+104 then
			enemy.left=false
			enemy.min_x=true
		end
	elseif enemy.min_x==true and enemy.direction==true then
		enemy.animation_wait=0.1
		enemy.x-=0.5
		if enemy.x==enemy.position_x then
			enemy.left=true
			enemy.min_x=false
		end
	end 
	if enemy.min_x==false and enemy.direction==false then
		enemy.animation_wait=0.1
		enemy.x+=0.5
		if enemy.x==enemy.position_x then
			enemy.left=false
			enemy.min_x=true
		end
	elseif enemy.min_x==true and enemy.direction==false then
		enemy.animation_wait=0.1
		enemy.x-=0.5
		if enemy.x==enemy.position_x-104 then
			enemy.left=true
			enemy.min_x=false
		end
	end 
end

function enemy2_ai()
	for enemy in all(enemies.enemy2) do
		if enemy.hp>0 then
			if time() - enemy.animation_time > enemy.animation_wait then
				enemy.sp+=1
				enemy.animation_time=time()
				if enemy.sp>146 then
					enemy.sp=145
				end
			end
			if player.y<=levels.level1.y then
				if enemy.direction==true then
					if player.x>=enemy.position_x+2 and player.x<=enemy.position_x+104 then
						if flr(player.x)>=enemy.x-104 and flr(player.x)<=enemy.x then
							if enemy.left==false then
								if player.immortality==false then
									enemy.animation_wait=0.02
									enemy.x-=2
								else
									enemy2_aniamte(enemy)
								end
							else
								enemy2_aniamte(enemy)
							end
						elseif flr(player.x)<=enemy.x+104 and flr(player.x)>=enemy.x then
							if enemy.left==true then 
								if player.immortality==false then
									enemy.animation_wait=0.02
									enemy.x+=2
								else
									enemy2_aniamte(enemy)
								end
							else
								enemy2_aniamte(enemy)
							end
						end						
					else
						enemy2_aniamte(enemy)
					end
				elseif enemy.direction==false then
					if player.x<=enemy.position_x and player.x>=enemy.position_x-102 then
						if flr(player.x)>=enemy.x-104 and flr(player.x)<=enemy.x then
							if enemy.left==false then
								if player.immortality==false then
									enemy.animation_wait=0.02
									enemy.x-=2
								else
									enemy2_aniamte(enemy)
								end
							else
								enemy2_aniamte(enemy)
							end
						elseif flr(player.x)<=enemy.x+104 and flr(player.x)>=enemy.x then
							if enemy.left==true then 
								if player.immortality==false then
									enemy.animation_wait=0.02
									enemy.x+=2
								else
									enemy2_aniamte(enemy)
								end
							else
								enemy2_aniamte(enemy)
							end
						end				
					else
						enemy2_aniamte(enemy)
					end
				end
			else
				enemy2_aniamte(enemy)
			end
		else
			del(enemies.enemy2,enemy)
			monsterCoutner()
		end
		if collide_spr(player, enemy) then	
			if player.immortality==false then
				enemies.collide=true
				player.immortality=true
				lossHp()
			end
			enemies.collide=false
		end
	end
end


--enemy3
function enemy3_animate(enemy)
	if time() - enemy.animation_time > enemy.animation_wait then
		if enemy.sp_shot==1 then
			enemy.sp=161
			enemy.sp_shot=0
		end
		enemy.sp+=1
		enemy.animation_time=time()
		if enemy.sp>162 then
			enemy.sp=161
		end
	end
	if enemy.min_x==true then
		enemy.x+=1
		if enemy.x==enemy.position_x then
			enemy.left=false
			enemy.min_x=false
		end
	elseif enemy.min_x==false then
		enemy.x-=1
		if enemy.x==enemy.position_x-20 then
			enemy.left=true
			enemy.min_x=true
		end
	end 
end

function enemy3_ai()
	for enemy in all(enemies.enemy3) do
		if enemy.hp>0 then
			shoot_cooldown(enemy)
			if flr(player.x)>=enemy.x-35 and flr(player.x)<=enemy.x 
			and flr(player.y)>=enemy.y and flr(player.y)<=enemy.y+8
			or flr(player.x)<=enemy.x+35 and flr(player.x)>=enemy.x 
			and flr(player.y)>=enemy.y and flr(player.y)<=enemy.y+8 then
				if enemy.t<0.1 then 
					if player.immortality==false then
						enemy.sp_shot=1
						enemy.sp=160	
						enemy.shot=true
					else
						enemy3_animate(enemy)
					end
				else
					enemy3_animate(enemy)
				end
			elseif flr(player.x)>=enemy.x-65 and flr(player.x)<=enemy.x+65 then
				enemy3_animate(enemy)
				enemy.shot=false
			end
		else
			del(enemies.enemy3,enemy)
			monsterCoutner()
		end
		if collide_spr(player, enemy) then	
			if player.immortality==false then
				enemies.collide=true
				player.immortality=true
				lossHp()
			end
			enemies.collide=false
		end
	end
end

--enemy4
function collide_player_bullet(player)
	for enemy_bomb in all(enemy_bombs)do
		if collide_spr(enemy_bomb, player)then
			enemies.collide=true
			player.immortality=true
			lossHp()
			enemies.collide=false
			del(enemy_bombs, enemy_bomb)
		end
	end

	for enemy_right_bomb in all(enemy_right_bombs)do
		if collide_spr(enemy_right_bomb, player)then
			enemies.collide=true
			player.immortality=true
			lossHp()
			enemies.collide=false
			del(enemy_right_bombs, enemy_right_bomb)
		end
	end

	for enemy_left_bomb in all(enemy_left_bombs)do
		if collide_spr(enemy_left_bomb, player)then
			enemies.collide=true
			player.immortality=true
			lossHp()
			enemies.collide=false
			del(enemy_left_bombs, enemy_left_bomb)
		end
	end
end

function enemy_fire(enemy)
	local enemy_bomb={}
	local enemy_left_bomb={}
	local enemy_right_bomb={}
	if enemy.type==4 then
		enemy_bomb={
			sp=150,
			x=enemy.x,
			y=enemy.y+4,
			dy=2,
			h=8,
			w=8	
		}	
		add(enemy_bombs, enemy_bomb)
	elseif enemy.type==3 then
		enemy_bomb={
			sp=151,
			x=enemy.x,
			y=enemy.y,
			dx=2,
			h=8,
			w=8	
		}
		if flr(player.x)>=enemy.x-35 and flr(player.x)<=enemy.x then
			add(enemy_left_bombs, enemy_bomb)	
		elseif flr(player.x)<=enemy.x+35 and flr(player.x)>=enemy.x then
			add(enemy_right_bombs, enemy_bomb)	
		end
	end

end

function enemy_fire_update() 
	for enemy_bomb in all(enemy_bombs) do
			enemy_bomb.y+=enemy_bomb.dy
	end
	for enemy_left_bomb in all(enemy_left_bombs) do
		enemy_left_bomb.x-=enemy_left_bomb.dx
		if enemy_left_bomb .x<=-8+cam_x then
			del(enemy_left_bombs ,enemy_left_bomb )
		end
	end
	for enemy_right_bomb in all(enemy_right_bombs) do
		enemy_right_bomb.x+=enemy_right_bomb.dx
		if enemy_right_bomb.x>128+cam_x then
			del(enemy_right_bombs,enemy_right_bomb)
		end
	end

end

function start_enemy4_animate(enemy)
	if enemy.start==true then 
		if enemy.min_y==false then
			enemy.y+=0.5
			if enemy.y==enemy.enemy_start_y-4 then
				enemy.min_y=true
			end
		elseif enemy.min_y==true then
			enemy.y-=0.5
			if enemy.y==enemy.position_y then
				enemy.min_y=false
			end
		end
	elseif enemy.start==false then
		if enemy.min_y==false then
			enemy.start=true
			enemy.min_y=true
		elseif enemy.min_y==true then
			enemy.start=true
		end
	end
	if enemy.min_x==true then
		enemy.x-=1
		if enemy.x==enemy.position_x-60 then
			enemy.left=true
			enemy.min_x=false
		end
	elseif enemy.min_x==false then
		enemy.x+=1
		if enemy.x==enemy.position_x+60 then
			enemy.left=false
			enemy.min_x=true
		end
	end 
end

function end_enemy4_animate(enemy)
	enemy.start=false
	if enemy.y>enemy.enemy_start_y then
		enemy.y-=0.5
		if enemy.x>enemy.position_x then
			enemy.x-=1 
		elseif enemy.x<enemy.position_x then
			enemy.x+=1

		elseif enemy.x==enemy.position_x then
			enemy.x+=0
		end

	elseif enemy.y<enemy.enemy_start_y then
		enemy.y+=0.5
		if enemy.x>enemy.position_x then
			enemy.x-=1 

		elseif enemy.x<enemy.position_x then
			enemy.x+=1

		elseif enemy.x==enemy.position_x then
			enemy.x+=0

		end
	elseif enemy.y==enemy.enemy_start_y then
		enemy.y+=0
		if enemy.x>enemy.position_x then
			enemy.x-=1 

		elseif enemy.x<enemy.position_x then
			enemy.x+=1

		elseif enemy.x==enemy.position_x then
			enemy.x+=0
			enemy.sp = 176
		end
	end
end



function enemy4_ai()
	for enemy in all(enemies.enemy4) do
		if enemy.hp>0 then
				shoot_cooldown(enemy) 
				if flr(player.x)>=enemy.position_x-65 and flr(player.x)<=enemy.position_x+65 then
					start_enemy4_animate(enemy)
					if time() - enemy.animation_time > enemy.animation_wait then
						enemy.sp+=1
						enemy.animation_time = time()
						if enemy.sp > 180 then
							enemy.sp = 176
						end
					end
					if flr(player.x)>=enemy.x-2 and flr(player.x)<=enemy.x+2  then
						if player.immortality==false then
							enemy.shot=true
						end
					-- elseif flr(player.x)<=enemy.x and flr(player.x)>=enemy.position_x  then
					-- 	if player.immortality==false then
					-- 		enemy.shot=true
					-- 	end
					else
						enemy.shot=false
					end
				else
					end_enemy4_animate(enemy)
				end
			-- else
			-- 	end_enemy4_animate(enemy)
			-- end
		else
			del(enemies.enemy4,enemy)
			monsterCoutner()
		end
		if collide_spr(player, enemy) then	
			if player.immortality==false then
				enemies.collide=true
				player.immortality=true
				lossHp()
			end
			enemies.collide=false
		end
	end
end

function boss_animation(enemy)
	if time() - enemy.animation_time > enemy.animation_wait then
		if enemy.shield==true then
			enemy.sp+=1
			enemy.animation_time = time()
			if enemy.sp > 204 then
				enemy.sp = 201
			end
		elseif enemy.shield==false then
			enemy.sp+=1
			enemy.animation_time = time()
			if enemy.sp > 200 then
				enemy.sp = 197
			end
		end
	end
end

function boss_ai()
	for enemy in all(enemies.boss) do
		if enemy.hp >0 then
			if levels.level3.countOfEnemies==1 then
				enemy.left=false
				if enemy.sp>=201 and enemy.sp<=204 then
					enemy.sp=197
				end
				enemy.shield=false

				if summon_cooldown(enemy) then
					enemy.shield=true
					if enemy.x!=enemy.position_x then
						boss_animation(enemy)
						enemy.x-=0.5 
					end
					if enemy.x==enemy.position_x then
						if enemy.min_y==true then
							enemy.y-=0.5
							enemy.sp=201
							if enemy.y==enemy.position_y-24 then
								enemy.min_x=true
								summon(enemy)
								enemy.min_y=false
								
							end
						end
					end
				end
			elseif levels.level3.countOfEnemies!=1 then
				if enemy.min_y==false then
					enemy.y+=0.5
					if enemy.y==enemy.position_y then
						enemy.min_y=true
						enemy.t=enemy.time
					end
				end
				if enemy.min_x==false and enemy.y==enemy.position_y then
					boss_animation(enemy)
					enemy.shield=true
					enemy.x-=0.5
					if enemy.x==enemy.position_x then
						enemy.left=true
						enemy.min_x=true
					end
				elseif enemy.min_x==true and enemy.y==enemy.position_y then
					boss_animation(enemy)
					enemy.x+=0.5
					if enemy.x==enemy.position_x+16 then
						enemy.left=false
						enemy.min_x=false
					end
				end
			end
		else
			del(enemies.boss,enemy)
			monsterCoutner()
		end
		if collide_spr(player, enemy) then	
			if player.immortality==false then
				enemies.collide=true
				player.immortality=true
				lossHp()
			end
			enemies.collide=false
		end
	end
end

function summon(enemy)
	draw_enemies(enemies.enemy1)
	if count(enemies.enemy1.EnemyNumberX)==0 then	
		add(enemies.enemy1.EnemyNumberX,120*8)
		add(enemies.enemy1.EnemyNumberX,117*8)
		add(enemies.enemy1.EnemyNumberX,114*8)
		enemies.enemy1.limit=0
	end 
end


function summon_cooldown(enemy)
	local fps=stat(8)
	enemy.dt=1/fps
	enemy.t=mid(0,enemy.t-enemy.dt,enemy.t)
	if enemy.t==0 then
		-- enemy.t=enemy.time
		
		return true
		-- summon(enemy)
		-- enemy.shield=false
		
	-- else
	-- 	boss_animation(enemy)
	end
	return false
end

function shoot_cooldown(enemy) 
	local fps=stat(8)
	enemy.dt=1/fps
	enemy.t=mid(0,enemy.t-enemy.dt,enemy.t)
	if enemy.t==0 and enemy.shot==true then 
		enemy_fire(enemy)
		enemy.t=enemy.time
	end
end

function monsterCoutner()
	if player.level==1 then
		levels.level1.countOfEnemies-=1
	elseif player.level==2 then
		levels.level2.countOfEnemies-=1
	elseif player.level==3 then
		levels.level3.countOfEnemies-=1
	end
end

-->8
--timer
function timer()
	if start==false then
		local fps=stat(8)
		dt=1/fps
		if ufo.moving==false then
			if t>0 then 
				t=mid(0,t-dt,t)
				if t<30 and t<switch_t then
					switch_t=t-0.1
					if t_color!=8 then
						t_color=8
					elseif t_color!=7 then
						t_color=7
					end
				end
				if t==0 then
					gameOver=true
				end
			end	
		end
	end
end

-->8
--Text endgame
function txt_width(txt)
	return 64-#txt*2
end

-->8
--animations

--weapon_animate
function weapon_animate()
	if player.weapon==false then
		if time() - weapon.animation_time > weapon.animation_wait then
			weapon.sp+=1
			weapon.animation_time=time()
			if weapon.sp>211 then
				weapon.sp=208
			end
		end
	end
end

--ammunition_animate
function ammunition_animate()
	for ammo in all(ammunition) do
		if collide_spr(player, ammo)==false then
			if time()- ammo.animation_time > ammo.animation_wait then
				ammo.sp+=1
				ammo.animation_time=time()
				if ammo.sp>243 then
					ammo.sp=240
				end
			end
		else
			bullets.limit+=10
			del(ammunition,ammo)
		end
	end
end

function collide_enemy_bullet(enemies)
	for enemy in all(enemies)do
		if enemy.shield==false then
			for bullet in all(bullets_left)do
				if collide_spr(bullet, enemy)then
					enemy.hp-=1
					del(bullets_left, bullet)
				end
			end

			for bullet in all(bullets_right)do
				if collide_spr(bullet,enemy) then
					enemy.hp-=1
					del(bullets_right,bullet)
				end
			end
		else
			for bullet in all(bullets_left)do
				if collide_spr(bullet, enemy)then
					del(bullets_left, bullet)
				end
			end

			for bullet in all(bullets_right)do
				if collide_spr(enemy, bullet) then
					del(bullets_right,bullet)
				end
			end
		end
	end
end

--water_animation
function water_animate()
	if time() - water.animation_time > water.animation_wait then
		water.sp +=1
		water.animation_time = time()
		if(water.sp > 195) then
			water.sp = 193
		end
	end
end

--player_animate
function player_animate()
	if player.jumping then
		if player.immortality then
			if time()-player.animation_time>0.05 then
				player.animation_time=time()
				player.sp+=3
				if player.sp>6 then
					player.sp=3
				end
			end
		else
			player.sp=3
		end
	elseif player.falling then
		if player.immortality then
			if time()-player.animation_time>0.05 then
				player.animation_time=time()
				if player.falling_sp==1 then 
					player.falling_sp=2
					player.sp=4
				elseif player.falling_sp==2 then
					player.falling_sp=1
					player.sp=6
				end
				-- player.sp+=2
				-- if player.sp>6 then
				-- 	player.sp=4
				-- end
			end
		else
			player.sp=4
		end
	elseif player.sliding then
			player.sp=5
	elseif player.running then
		if time()-player.animation_time>0.05 then
			player.animation_time=time()
			if player.immortality then
				if player.immortality_sp==1 then
					player.immortality_sp=2
					player.sp=1
				elseif player.immortality_sp==2 then
					player.immortality_sp=3
					player.sp=6
				elseif player.immortality_sp==3 then
					player.immortality_sp=4
					player.sp=2
				elseif player.immortality_sp==4 then
					player.immortality_sp=1
					player.sp=6
				end
			else 
				player.sp+=1
				if player.sp>2 then
					player.sp=1
				end
			end
		end
	elseif player.panic then
		if time()-player.animation_time>0.5 then
			player.animation_time=time()
			player.sp+=5
			if player.sp>33 then
				player.sp=32
			end
		end
	else
		if player.immortality then
			if time()-player.animation_time>0.1 then
				player.animation_time=time()
				player.sp+=6
				if player.sp>6 then
					player.sp=0
				end
			end
		else
			player.sp=0	
		end
	end
	if ufo.teleport then
		if flr(player.x)==flr(ufo.x) then
			player.panic=true
			player.sp=32
			player.y-=0.3
		end
		if flr(player.y)==flr(ufo.laser.y) then 
			nextLevel()
		end
	end
	if player.level==3 and levels.level3.countOfEnemies==0  then
		nextLevel()
	end
end

--ufo_animate
function ufo_animate()
	if ufo.x<=player.x+83 and ufo.x>=player.x-83 and player.level==1 and levels.level1.countOfEnemies==0 then
		ufo.moving=true
		if flr(player.x) > flr(ufo.x) then
			ufo.x+=1
		elseif flr(player.x) < flr(ufo.x) then
			ufo.x-=1
		elseif flr(player.x) == flr(ufo.x) then
			ufo.x=player.x
			player.sp=0
			ufo.teleport=true
		end
	end
		
	if ufo.teleport then
		if time() - ufo.animation_time > ufo.animation_wait then
			ufo.animation_time = time()
			ufo.sp-=1
			ufo.laser.sp1-=1
			ufo.laser.sp2-=1
			if ufo.laser.sp1 < 157 then
				ufo.sp = 142
				ufo.laser.sp1=158
				ufo.laser.sp2=174
			end
		end
	end
end

--door function
function door_animate_open() 
	if player.level==2 and doors.door.open then
		if time()-doors.door.animation_time> doors.door.animation_wait then
			doors.door.animation_time = time()
			doors.door.sp1+=2
			doors.door.sp2+=2
			doors.door.sp3+=2
			doors.door.sp4+=2
			doors.door.sp5+=2
			doors.door.sp6+=2
			if doors.door.sp1 > 86 then
				doors.door.sp1=86
				doors.door.sp2=87
				doors.door.sp3=102
				doors.door.sp4=103
				doors.door.sp5=118
				doors.door.sp6=119

				doors.open=false
				doors.door.opened=true
			end
		end
	end
end

function door_animate_close() 
	if doors.door2.opened then
		if time()-doors.door2.animation_time> doors.door2.animation_wait then
			doors.door2.animation_time = time()
			doors.door2.sp1+=2
			doors.door2.sp2+=2
			doors.door2.sp3+=2
			doors.door2.sp4+=2
			doors.door2.sp5+=2
			doors.door2.sp6+=2
			if doors.door2.sp1 > 94 then
				doors.door2.sp1=94
				doors.door2.sp2=95
				doors.door2.sp3=110
				doors.door2.sp4=111
				doors.door2.sp5=126
				doors.door2.sp6=127

				doors.door2.opened=false
			end
		end
	end
end

--platform function
function platform_animate()
	if player.level==2 then
		if platform.min_y==false then
			platform.y+=1
			if platform.y==platform.y_end then
				platform.min_y=true
				player.movement_platform_down=false
			end
		elseif platform.min_y==true then
			platform.y-=1
			if platform.y==platform.y_start then
				platform.min_y=false
				player.movement_platform_down=true
			end
		end
	end
end	


function collide_platform(obj, spr)
	local x1=spr.x1
	local x2=spr.x2
	local x3=spr.x3
	local x4=obj.x
	local y1=obj.y
	local y2=spr.y
	local h=spr.h
	local w=spr.w

	x1=flr(x1)	x2=flr(x2)
	x3=flr(x3)	x4=flr(x4)
	y1=flr(y1)	y2=flr(y2)

	for i=0, 3, 1 do 
		if x4>=x1-4 and x4<=x3+3 and y1==y2+i 
		or x4>=x1-4 and x4<=x3+3 and y1==y2-i then
			player.onPlatform=true
			return true
		else
			player.onPlatform=false
		end
	end
end

--loss life
function lossHp()
	player.hp-=1
	if player.level==1 then
		if enemies.collide==false then
			player.x=8
			player.y=32
			player.immortality=true
		end
	elseif player.level==2 then
		if enemies.collide==false then
			player.x=8
			player.y=200
			player.immortality=true
		end
	elseif player.level==3 then
		if enemies.collide==false then
			player.x=888
			player.y=184
			player.immortality=true
		end	
	end
end

function restartGame()
	if btnp(🅾️) then
		_init()
		start=false
	end
end


-->8
--controls
function controls()
	if btn(⬅️) then
		player.dx-=player.acc
		player.running=true
		player.left=true
	end
	--right
	if btn(➡️) then
		player.dx+=player.acc
		player.running=true
		player.left=false
	end
	--jump
	if btnp(⬆️) and player.landed then
		player.dy-=player.boost
		player.jumping=true
		player.landed=false
	end
	--down
	if btnp(⬇️) and player.landed and player.level==1 then
		player.sliding=true
		player.running=false
		player.colide=false
	end

	if btnp(🅾️)then
		if start==true then
			start=false
		end
		if levels.level2.countOfEnemies==0 then
			doors.door.open=true
		end
	end

	if btnp(❎) and player.weapon and bullets.limit>0 then
		fire()
		bullets.limit-=1
	end

	if player.running 
	and not btn(⬅️) 
	and not btn(➡️) then
		player.running=false
		player.dx=0
	end

	if player.sliding
	and not btnp(⬇️) then
		player.sliding=false
		player.colide=true
		player.landed=false
	end
	player.x+=player.dx
	player.y+=player.dy
end

-->8
-->map collision
function collision()
	--weapon collision
	if collide_spr(player, weapon) then
		player.weapon=true
	end

	--door collision next level
	if doors.door.opened and levels.level2.countOfEnemies==0 and flr(player.x)>doors.door.x1-1 then
		nextLevel()
	end

	if doors.door2.opened==false and player.level==3 and flr(player.x)==doors.door2.x2+4 then
		doors.door2.opened=true
	end
	
	--collision up/down
	if player.dy<0 and player.dx>0 then
		if collide_map(player, "up",0) then
			player.x+=player.dx
		end
	elseif player.dy<0 and player.dx<0 then
		if collide_map(player, "up",0) then
			player.x+=player.dx
		end
	end
	if player.dy>0 and player.colide==true then
		player.falling=true
		player.landed=false
		player.jumping=false

		if collide_map(player, "down", 0) then
			player.landed=true
			player.falling=false
			player.dy=0
			player.y-=(player.y+player.h)%8
		end
		if collide_map(player, "down", 3) then
			player.landed=true
			player.falling=false
			player.dy=0
			player.y-=(player.y+player.h)%8
		end
		
		if collide_platform(player, platform) then
			player.landed=true
			player.falling=false
			player.dy=0
			if player.movement_platform_down==true then
				player.y=platform.y-1
			else
				player.y=platform.y-3
			end
		end

		if collide_map(player, "down", 6)then
			lossHp()
		end
	elseif player.colide==false then
		if collide_map(player, "down", 0) then
			player.y+=8
			player.colide=true
		end
	end

	-- collision left/right
	if player.dx<0 then
		if collide_map(player, "left", 0) then
			player.x-=player.dx
		end
		if collide_map(player, "left", 3) then
			player.x-=player.dx
		end
	elseif player.dx>0 then
		if collide_map(player, "right", 0) then
			player.x-=player.dx
		end
		if collide_map(player, "right", 3) then
			player.x-=player.dx
		end
	end
end		

--collisions with sprites
function collide_spr(obj, spr)

	--tutaj
	local x1=obj.x
	local x2=spr.x
	local y1=obj.y
	local y2=spr.y

	x1=flr(x1)	x2=flr(x2)
	y1=flr(y1)	y2=flr(y2)

	if ufo.teleport==false then
		if y1>y2-4 and y1<y2+4 then 
			if x1>x2-4 and x1<x2+4 then
				return true
			end
		end
		return false
	else
		if x1>x2-4 and x1<x2+4 then
			return true
		end
		return false
	end

end

--collisions with map sprites
function collide_map(obj, aim, flag)
	local x=obj.x	local y=obj.y
	local h=obj.h	local w=obj.w

	local x1=0	local x2=0
	local y1=0	local y2=0
	
	if aim=="left" then
		x1=x		y1=y
		x2=x    	y2=y+h-1
	elseif aim=="right" then
		x1=x+w-1		y1=y
		x2=x+w-1		y2=y+h-1
	elseif aim=="up" then
		x1=x   		y1=y		
		x2=x+w		y2=y
	elseif aim=="down" then
		x1=x+3      y1=y+h
		x2=x+w-2    y2=y+h
	end


	--pixels to tiles
	x1=x1/8		x2=x2/8
	y1=y1/8		y2=y2/8	
	
	--check collision
	if fget(mget(x1,y1), flag)
	or fget(mget(x1,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
		return true
	else
		return false
	end
end

function door_update()
	door_animate_open()
	door_animate_close()
end

function enemy_update()
	enemy1_ai()
	enemy2_ai()
	enemy3_ai()
	enemy4_ai()
	boss_ai()
end

-->8
--UPDATE

--update_game
function _update60()
	if gameOver then
		restartGame()
	elseif gameOver==false then
		timer()
		player_update()
		fire_update()
		enemy_fire_update()
		door_update()
		enemy_update()
		weapon_animate()
		water_animate()
		ufo_animate()		
		ammunition_animate()
		platform_animate()	
		draw_ammunition()
		draw_enemy()
		collide_enemy_bullet(enemies.enemy1)
		collide_enemy_bullet(enemies.enemy2)
		collide_enemy_bullet(enemies.enemy3)
		collide_enemy_bullet(enemies.enemy4)
		collide_enemy_bullet(enemies.boss)
		collide_player_bullet(player)
		simpleCamera()	
	end
end

--Fire update
function fire_update()
	if player.left  then
		for bullet in all(bullets_left) do
			bullet.x-=bullet.dx
			if bullet.x<-8+cam_x then
				del(bullets_left,bullet)
			elseif collide_map(bullet, "left", 2) then
				del(bullets_left, bullet)
			elseif collide_map(bullet, "right", 2) then
				del(bullets_right, bullet)
			end
		end
		for bullet in all(bullets_right) do
			bullet.x+=bullet.dx
			if bullet.x>128+cam_x then
				del(bullets_right,bullet)
			elseif collide_map(bullet, "left", 2) then
				del(bullets_left, bullet)
			elseif collide_map(bullet, "right", 2) then
				del(bullets_right, bullet)
			end
		end
	else
		for bullet in all(bullets_right) do
			bullet.x+=bullet.dx
			if bullet.x>128+cam_x then
				del(bullets_right,bullet)
			elseif collide_map(bullet, "left", 2) then
				del(bullets_left, bullet)
			elseif collide_map(bullet, "right", 2) then
				del(bullets_right, bullet)
			end
		end
		for bullet in all(bullets_left) do
			bullet.x-=bullet.dx

			if bullet.x<-8+cam_x then
				del(bullets_left,bullet)
			elseif collide_map(bullet, "left", 2) then
				del(bullets_left, bullet)
			elseif collide_map(bullet, "right", 2) then
				del(bullets_right, bullet)
			end
		end
	end
end

--player_update
function player_update()
	player_animate()
	if(ufo.teleport==false) then
		--gravity 
		player.dy+=gravity
		--friction
		player.dx*=friction

		--gameOver
		if player.hp==0 then
			gameOver=true
		end
		
		--controls
		controls()

		--immortality
		immortality()

		--collsion
		collision()
	end
end

--map update
function nextLevel()
	if player.level==1 then 
        t=120
		t_color = 7 
		switch_t = t
		player.level=2
		player.x=8
		player.y=200
		player.hp+=1
		ufo.teleport=false
		ufo.moving=false
		player.panic=false
		bullets.limit+=40
	elseif player.level==2 then
        t=120
		t_color = 7 
		switch_t = t
		player.level=3
		player.x=880
		player.y=184
		player.hp+=1
		bullets.limit+=40
		doors.door.opened=false
	elseif player.level==3 then
		gameOver=true
	end
end

function immortality()
	if player.immortality==true then
		local fps=stat(8)
		player.dt=1/fps
		player.t=mid(0,player.t-player.dt,player.t)
		if player.t==0 then 
			player.immortality=false
			player.t=3
		end
	end
end
 
-->8
--draw
function _draw()
	if start==true then
		cls()
		map(0,0,0,0,128,32)
		spr(231,45,35)
		spr(232,55,35)
		spr(233,65,35)
		spr(234,75,35)
		spr(235,85,35)
		spr(245,30,45)
		spr(246,40,45)
		spr(247,50,45)
		spr(248,60,45)
		spr(249,70,45)
		spr(250,80,45)
		spr(251,90,45)
		spr(252,100,45)
		print("press 🅾️ to start game.", 20+cam_x, 60+cam_y, 7)
	elseif start==false then 
		cls()
		map(0,0,0,0,128,32)
		--draw ufo
		spr(ufo.sp, ufo.x, ufo.y)
		if ufo.teleport then
			spr(ufo.laser.sp1, ufo.x, ufo.laser.y)
			for i=player.y, ufo.laser.y, -8 do
				spr(ufo.laser.sp2, ufo.x, i)
			-- spr(ufo.laser.sp2, ufo.x, ufo.laser.y3)
			end
		end

		--draw doors

		--draw door
		spr(doors.door.sp1, doors.door.x1, doors.door.y1)
		spr(doors.door.sp2, doors.door.x2, doors.door.y1)
		spr(doors.door.sp3, doors.door.x1, doors.door.y2)
		spr(doors.door.sp4, doors.door.x2, doors.door.y2)
		spr(doors.door.sp5, doors.door.x1, doors.door.y3)
		spr(doors.door.sp6, doors.door.x2, doors.door.y3)

		--draw door2
		spr(doors.door2.sp1, doors.door2.x1, doors.door2.y1)
		spr(doors.door2.sp2, doors.door2.x2, doors.door2.y1)
		spr(doors.door2.sp3, doors.door2.x1, doors.door2.y2)
		spr(doors.door2.sp4, doors.door2.x2, doors.door2.y2)
		spr(doors.door2.sp5, doors.door2.x1, doors.door2.y3)
		spr(doors.door2.sp6, doors.door2.x2, doors.door2.y3)

		--draw platform
		spr(platform.sp, platform.x1, platform.y)
		spr(platform.sp, platform.x2, platform.y)
		spr(platform.sp, platform.x3, platform.y)

		
		--draw weapon and player
		if player.weapon==false then
			spr(player.sp, player.x, player.y, 1, 1, player.left)
			spr(weapon.sp, weapon.x, weapon.y)	
		elseif player.weapon then
			spr(player.sp+16, player.x, player.y, 1, 1, player.left)
		end
		

		--draw enemies
		
		--draw enemy1
		for enemy in all(enemies.enemy1) do
			spr(enemy.sp, enemy.x, enemy.y, 1, 1, enemy.left)
		end

		--draw enemy2
		for enemy in all(enemies.enemy2) do
			spr(enemy.sp, enemy.x, enemy.y, 1, 1, enemy.left)
		end

		--draw enemy3
		for enemy in all(enemies.enemy3) do
			spr(enemy.sp, enemy.x, enemy.y, 1, 1, enemy.left)
		end

		--draw enemy4
		for enemy in all(enemies.enemy4) do
			spr(enemy.sp, enemy.x, enemy.y, 1, 1, enemy.left)
		end

		--draw boss enemy
		for enemy in all(enemies.boss)do
			spr(enemy.sp, enemy.x, enemy.y, 1, 1, enemy.left)
		end
		

		--draw_ammunition
		for ammo in all(ammunition) do
			spr(ammo.sp, ammo.x, ammo.y)
		end

		--draw watter
		for j = water.x1, map_end, 8 do
			spr(water.sp, j, water.y1)
		end


		for j = water.x2, map_end, 8 do
			spr(water.sp, j, water.y2)
		end

		for j = water.x2, map_end, 8 do
			spr(water.sp, j, water.y2+8)
		end

		--draw bullets
		sspr( (bullets.sp%16)*8, (bullets.sp/16)*8,  6 ,  4 ,  93+cam_x, -2+cam_y, 12, 8 )
		-- sspr(bullets.sp,100+cam_x, 1)

		for bullet in all(bullets_right) do
			spr(bullet.sp, bullet.x, bullet.y)
		end

		for bullet in all(bullets_left) do
			spr(bullet.sp, bullet.x, bullet.y, 1, 1, player.left)
		end
		
		for enemy_bomb in all(enemy_bombs) do
			spr(enemy_bomb.sp, enemy_bomb.x, enemy_bomb.y)
		end

		for enemy_left_bomb in all(enemy_left_bombs) do
			spr(enemy_left_bomb.sp, enemy_left_bomb.x, enemy_left_bomb.y)
		end

		for enemy_right_bomb in all(enemy_right_bombs) do
			spr(enemy_right_bomb.sp, enemy_right_bomb.x, enemy_right_bomb.y)
		end

		--draw hp
		local b=0
		for i=player.hp,1,-1 do
			spr(hp.sp, hp.x+b+cam_x, hp.y+cam_y)
			b+=8 	
		end

		if player.level==3 then
			for enemy in all(enemies.boss) do
				print("enemy_hp:", 50+cam_x, 25+cam_y, 7)
				local a=0
				for i=enemy.hp,1,-1 do 
					spr(135,40+a+cam_x,168)
					a+=1
				end
				-- print(enemy.hp/enemy.hp_max, 68+cam_x, 33+cam_y, 7)
			end
		end

		--timer
		local cur_t=flr(t*10)/10
		local formatted_t=cur_t..""
		
		if(cur_t%1==0)then
			formatted_t=formatted_t..".0"
		end
		print(formatted_t, txt_width(formatted_t)+cam_x, 2+cam_y, t_color)

		print(bullets.limit, 108+cam_x, 2+cam_y, 7)
	end
	
-- draw Game Over or time's up or congratulations or startgame
	if t==0 and player.level!=0 then
		print("time's up!", 44+cam_x, 44+cam_y, 10)
		print("game over!", 44+cam_x, 52+cam_y, 7)
		print("press 🅾️ to restart game.", 15+cam_x, 60+cam_y, 7)
	end
	if gameOver then
		if player.level==3 and levels.level3.countOfEnemies==0 then
			print("congratulations !!", 35+cam_x, 38+cam_y, 7)
			print("you won the game !", 35+cam_x, 48+cam_y, 7)
		else
			print("game over!", 44+cam_x, 52+cam_y, 7)
			print("press 🅾️ to restart game.",15+cam_x, 60+cam_y, 7)
		end
	end
end

__gfx__
000eeeee000eeeeeee0eeeee000eeeee000eeeee00000000000000000000000000000000bbbbbbbbbbbbbbbb33bbb33b11111111540000000000000000000045
000eeeeee0eeeeee00eeeeee00eeeeee00eeeeee0eeeee00000000000000000000000000bbbbbbbbbbb3bbb333b3333b11111111400bb3b3b33b3b3bbb3bb004
000e73f30e0ef73f000ef73f0e0ef73f0e0ef73f0eeeee00000000000000000000000000333333333b333b333bb333b311ccc11100bb3bb33bb33bb3b3bb3b00
000eeeee000eeeee000eeeeee00eeeeee00eeeee0e73f30000000000000000000000000044445444435443b44b3443bb1cc1c11103bbb33bb333bb3bb333b3b0
0000ee000feee0000feee0000feee0000000eee00eeeee0000000000000000000000000055545454444543b44b34553bcc111c11703b30303b03b3033b0bb307
000eeee0000ee000000ee000000ee0000000ee0f00eeeef0000000000000000000000000445555555454443443445443c1111c111703070700700070b070b071
00feeeef0ee0200000e20000002e000000000e200f0ee200000000000000000000000000455545444544545454455544111111ccc170717177c7071707170711
000e00e00000200000e2000002e00000000000e20000ee22000000000000000000000000544445544454454545554554111111111c11c11c1c1171c171117111
0eeeee00000eeeeeee0eeeee000eeeee000eeeee00000000000000000000000000000000445454454454544540004444445454454454507777054544ccc55ccc
0eeeee00e0eeeeee00eeeeee00eeeeee00eeeeeeeeeee000000000000000000000000000445544544455445407770404445544544455077117705544cc5555cc
0e73f3000e0ef73f000ef73f0e0ef73f0e0ef73feeeee000000000000000000000000000445444554454445507117070445444554450711111170544c555555c
0eeeee00000eeeee000eeeeee00eeeeee00eeeeee73f300000000000000000000000000055544554555445547111171755540004555407111170455555555555
00ee0aaa000eeaaa000eeaaa000eeaaa0000eee0eeeee0000000000000000000000000004455554444555544111c111140507770405077111177050466666666
0eeee800000ee800000ee800000ee8000000eeaa0eeeeaaa000000000000000000000000445555444455554411c1c111070711700707111111117070c555555c
feeee0000ee0200000e20000002e000000000e80f0ee280000000000000000000000000045544554455445541c111c1c717111177171111111111717cc6666cc
0e00e0000000200000e2000002e00000000000e2000ee2200000000000000000000000004544454545444545c11111c1711111117111111111111117cc0cc0cc
00eeeee000eeeee00000000000000000ccc0000000000ccc45400000000000000000000000000000000004540454544544545440cccb3ccccccccccccccccccc
00eeeee000eeeee00000000000000000cc0bbb3bbb3bb0cc540bbb3bbbbbbbbbbbbbbbbbbbbbbbbbbb3bb0450455445444554450cc33b3cccccccccccccccccc
00e73f3000e73f300000000000000000c0bb33bbb3bb3b0c40bb33bbbbbbbbbbbbbbbbb3bbb33bbbb3bb3b040454445544544450c3b3233cccccccccccc77ccc
00eeeee000eeeee00000000000000000033333333333333003333333333333333b3bbb333bb303bb3333333005544554555445503233b33bcccccccccc7777cc
0f0ee0f0000ee0000000000000000000003000300300030000300030000000000303b3300b305030030003000455554444555540b3333323ccccccccc777777c
00eeee000feeeef00000000000000000040505044050504004050504544545544050303003005404405050400455554444555540cc3b33ccccccccccc777777c
00eeee0000eeee000000000000000000055555455455555005555545455555455445050400455544545555500554455445544550ccc44ccccccccccccccccccc
00e00e0000e00e000000000000000000054545544554545005454554554545544554444544554554455454500544454545444540ccc44ccccccccccccccccccc
0000000000000000000000000000000000000000c000cccc00000000454bbbbbbbbbb45411111111ccc44cccccc44cccccc44cccccc44cccccc44ccccccccccc
000000000000000000000000000000000000000007770c0c0000000054bbbbbbbbbbbb4511111111ccc44cccccc44cccccc44cccccc44cccccc44ccccccccccc
00000000000000000000000000000000000000000711707000000000433333333333333411111111ccc44cccccc44cccccc44cccccc44cccccc44ccccccccccc
00000000000000000000000000000000000000007111171700000000404444400444440411111111ccc44cccbbb44333bbb44bbb3334433333344bbbcccccccc
0000000000000000000000000000000000000000111c111100000000070050077005007011111111ccc44cccbbb44333bbb44bbb3334433333344bbbcccccccc
000000000000000000000000000000000000000011c1c11100000000717707711770771711111111ccc44cccbbb44333bbb44bbb3334433333344bbbc3ccc3cc
00000000000000000000000000000000000000001c111c1c00000000111171111117111111111111ccc44cccc4c44c4cc4c44c4cc4c44c4cc4c44c4c333c333c
0000000000000000000000000000000000000000c11111c100000000111111111111111111111111ccc44cccc4c44c4cc4c44c4cc4c44c4cc4c44c4cc4ccc4cc
0000000000000000000000005555555566767666666666665555555555555555dddddddd55555555000000000000000075555555666666666666666666666666
08808800000aaa00000000005995999566767666666666669959999959959999dddddddd99599995000000000000000097599997666666666666666666666666
8888888000aaaaa0000000005995999577777776666666669959999959959999dddddddd99599995000000000000000099777979466666666664666666666646
8888888000aaaaa00000000055555555777c7776666666665555555555555555dddddddd55555555000000000000000055755755646666666664666666666466
0888880000aaaaa000a888005999599577cac776666666669999959959999599dddddddd99995995000000000000000099799579664666666664666666664666
0088800000aaaaa000000000599959957cfcfc76666666669999959959999599dddddddd99995995000000000000000097997799666466666664666666646666
00080000000aaa000000000059995995cacfcac6666666669999959959999599dddddddd99995995000000004444444477779579665556666655566666555666
000000000000000000000000555555556cacac66666666665555555555555555dddddddd55555555000000004444444475575557665556666655566666555666
6666999999996666666699999999666666669999999966666666999999996666dddd99999999dddddddd99999999dddddddd99999999dddddddd99999999dddd
6669444994449666666949dddd9496666669dddddddd96666669dddddddd9666ddd9666666669dddddd9666666669dddddd9496666949dddddd9444994449ddd
6694444994444966669449dddd9449666699dddddddd9966669dddddddddd966dd966666666669dddd996666666699dddd944966669449dddd944449944449dd
6944444994444496694449dddd9444966949dddddddd9496699dddddddddd996d99666666666699dd94966666666949dd94449666694449dd94444499444449d
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444994994994449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444994994994449
9444994994994449944949dddd9494499499dddddddd9949949dddddddddd9499496666666666949949966666666994994494966669494499444994994994449
9444994994994449944949dddd9494499499dddddddd9949949dddddddddd9499496666666666949949966666666994994494966669494499444994994994449
9444994994994449944949dddd9494499449dddddddd9449949dddddddddd9499496666666666949944966666666944994494966669494499444994994994449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
9444444994444449944449dddd9444499449dddddddd9449949dddddddddd9499496666666666949944966666666944994444966669444499444444994444449
944444499444444994449dddddd94449949dddddddddd949949dddddddddd9499496666666666949949666666666694994449666666944499444444994444449
94444449944444499449dddddddd944999dddddddddddd9999dddddddddddd999966666666666699996666666666669994496666666694499444444994444449
9999999999999999999dddddddddd9999dddddddddddddd99dddddddddddddd99666666666666669966666666666666999966666666669999999999999999999
003333000003330000033300000000000000000000000000000000000000000000000000868686868d8d8d8d0000000000000000cccddccccccddccccccddccc
003873000008330000083300000000000000000000000000000000000000800000000000464646464d4d4d4d0000000000000000ccddddccccddddccccddddcc
003333000003330000033300000000000000000000000000000000000000800000000000464646464d4d4d4d0000000000000000cddddddccddddddccddddddc
00033000000030000000300000000000000000000000000000000000000080000000000048484848484848480000000000000000dddddddddddddddddddddddd
00333300000033300000333000000000000000000000000000000000000080000000000044444444444444440000000000000000666666666666666666666666
0b3333b0000030000000300000000000000000000000000000000000000080000000000099999599999995990000000000000000cddddddccddddddccddddddc
0033330000003bb00000b33000000000000000000000000000000000000000000000000099999599999995990000000000000000cc6666cccc6666cccc6666cc
00300300000030000000b00000000000000000000000000000000000000000000000000055555555555555550000000000000000cccaacccccc99ccccccccccc
066666000066600000666000006660000066600000000000000aa000000000000000000000000000000000000000000000000000cc9999ccccaaaacc00000000
0622260000266000002660000026600000266000000000000aa99aa0000000000000000000000000000000000000000000000000caaaaaacc999999c00000000
066666000066600000666000006660000066600000000000a99ff99a000bb000000000000000000000000000000000000000000099999999aaaaaaaa00000000
000600000006000000060000000600000006000000000000a9f9af9a00b88b000000000000000000000000000000000000000000aaaaaaaa9999999900000000
666666600006660000066600005660000556600000000000a9fa9f9a000bb000000000000000000000000000000000000000000099999999aaaaaaaa00000000
606660600006000000060000000600000006000000000000a99ff99a000000000000000000000000000000000000000000000000aaaaaaaa9999999900000000
0060600000065500000566000060500000605000000000000aa99aa000000000000000000000000000000000000000000000000099999999aaaaaaaa00000000
006060000006000000050000006050000060500000000000000aa000000000000000000000000000000000000000000000000000aaaaaaaa9999999900000000
0a0a0a0000a0a0a000a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000099999999aaaaaaaa00000000
a2aaa2a0000aaa00000aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaa9999999900000000
0a6a6a0000a6a00000a6a0000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999aaaaaaaa00000000
00a8a000008aa000008aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaa9999999900000000
0aaaaa000000aaa00000aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000099999999aaaaaaaa00000000
00aaa0000000a0000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaa9999999900000000
00aaa0000000a99000009aa00000000000000000000000000000000000000000000000000000000000000000000000000000000099999999aaaaaaaa00000000
00a0a0000000a0000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000aaaaaaaa9999999900000000
09999900009990000009000000999000099999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090000000900000009000000090000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaa00000aaa00000aaa00000aaa00000aaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
508aa050508aa050508aa050508aa050508aa0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50222050502220505022205050222050502220500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55525550555255505552555055525550555255500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55252550552525505525255055252550552525500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02000200020002000200020002000200020002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111100000000ffffffff0022220000222200002222000022220000cccc0000cccc0000cccc0000cccc00000000000000000000000000
11111111111111111111111100000000ffffffff02eeee2002eeee2002eeee2002e8ee200cc22cc00cc22cc00cc22cc00cc22cc0000000000000000000000000
11111111111111111111111100000000ffffffff2e4eeee22eeeeee22eeeeee22ee8e4e2cc2ee2cccc2ee2cccc2ee2cccc28e2cc000000000000000000000000
1111111111cc11111111cc1100000000ffffffff2eeeeee22eeeeee22eeee8822eeeeee2c2e4ee2cc2eeee2cc2eee82cc2ee4e2c000000000000000000000000
111111111c11c111111c11c100000000ffffffff288eeee22eeeeee22eeeeee22eeeeee2c28eee2cc2e4ee2cc2ee4e2cc2eeee2c000000000000000000000000
111111111c111c1111c111c100000000ffffffff2eeeeee22e4e8ee22eeee4e22eeeeee2cc2ee2cccc2e82cccc2ee2cccc2ee2cc000000000000000000000000
11111111c11111cccc11111c00000000ffffffff02eeee2002ee8e2002eeee2002eeee200cc22cc00cc22cc00cc22cc00cc22cc0000000000000000000000000
11111111111111111111111100000000ffffffff0022220000222200002222000022220000cccc0000cccc0000cccc0000cccc00000000000000000000000000
00000000000000000000000000000000ffffffff0000000000000000000550000500000000050000055555500500005000000000000000000000000000000000
00000000000000000000000000000000ffffffff02eeee2002eeee2002eeee2002e8ee200cc22cc00cc22cc00cc22cc00cc22cc0000000000000000000000000
00000000000000000000000000000000ffffffff2e4eeee22eeeeee22eeeeee22ee8e4e2cc2ee2cccc2ee2cccc2ee2cccc28e2cc000000000000000000000000
00aaaa00000a000000aaaa00000a0000ffffffff2eeeeee22eeeeee22eeee8822eeeeee2c2e4ee2cc2eeee2cc2eee82cc2ee4e2c000000000000000000000000
00800000000800000000080000080000ffffffff288eeee22eeeeee22eeeeee22eeeeee2c28eee2cc2e4ee2cc2ee4e2cc2eeee2c000000000000000000000000
00000000000000000000000000000000ffffffff2eeeeee22e4e8ee22eeee4e22eeeeee2cc2ee2cccc2e82cccc2ee2cccc2ee2cc000000000000000000000000
00000000000000000000000000000000ffffffff02eeee2002ee8e2002eeee2002eeee200cc22cc00cc22cc00cc22cc00cc22cc0000000000000000000000000
00000000000000000000000000000000ffffffff0022220000222200002222000022220000cccc0000cccc0000cccc0000cccc00000000000000000000000000
00000000000000000000000000000000ffffffff0000000000000000000aa000aa000000000aa000aaaaaaa0aa0000aa00000000000000000000000000000000
00000000000000000000000000000000ffffffff00000000000000000aaaaaa0aa000000000aa000aaaaaaa0aaa000aa00000000000000000000000000000000
00000000000000000000000000000000ffffffff00000000000000000aa00aa0aa000000000aa000aa000000aaaa00aa00000000000000000000000000000000
00000000000000000000000000000000ffffffff0000000000000000aa0000aaaa000000000aa000aaaaaa00aaaaa0aa00000000000000000000000000000000
00000000000000000000000000000000ffffffff0000000000000000aa0000aaaa000000000aa000aaaaaa00aa0aaaaa00000000000000000000000000000000
00000000000000000000000000000000ffffffff0000000000000000aaaaaaaaaa000000000aa000aa000000aa00aaaa00000000000000000000000000000000
00000000000000000000000000000000ffffffff0000000000000000aaaaaaaaaaaaaaaa000aa000aaaaaaa0aa000aaa00000000000000000000000000000000
00000000000000000000000000000000ffffffff0000000000000000aa0000aaaaaaaaaa000aa000aaaaaaa0aa0000aa00000000000000000000000000000000
0000000000000000000000000000000000000000000ee000ee0000eee000000e000ee0000eeeeeee000ee00000eeee00ee0000ee000000000000000000000000
0000000000000000000000000000000000000000000ee000eee000eeee0000ee0eeeeee0eeeeeeee000ee0000eeeeee0eee000ee000000000000000000000000
0000000000000000000000000000000000000000000ee000eeee00eeee0000ee0ee00ee0ee00000e000ee000ee0000eeeeee00ee000000000000000000000000
00a88800000a000000888a000008000000000000000ee000eeeee0ee0ee00ee0ee0000ee0eeeee00000ee000ee0000eeeeeee0ee000000000000000000000000
0000000000000000000000000000000000000000000ee000ee0eeeee0ee00ee0ee0000ee000000ee000ee000ee0000eeee0eeeee000000000000000000000000
00a99a0000a99a0000a99a0000a99a0000000000000ee000ee00eeee0ee00ee0eeeeeeeee00000ee000ee000ee0000eeee00eeee000000000000000000000000
0a9999a00a9999a00a9999a00a9999a000000000000ee000ee000eee00eeee00eeeeeeeeeeeeeeee000ee0000eeeeee0ee000eee000000000000000000000000
a999999aa999999aa999999aa999999a00000000000ee000ee0000ee000ee000ee0000ee0eeeeee0000ee00000eeee00ee0000ee000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88888888888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8888eee8888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111d1d1ddd1ddd1ddd1ddd1ddd1d111ddd11dd111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111d1d1d1d1d1d11d11d1d1d1d1d111d111d11111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ddd1ddd1d1d1ddd1dd111d11ddd1dd11d111dd11ddd111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ddd1d1d1d1d11d11d1d1d1d1d111d11111d111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111d11d1d1d1d1ddd1d1d1ddd1ddd1ddd1dd1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111666166116661666117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616661161117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111666161116661616166616661111111111111177111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111616161116161616161116161111177711111171111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111666161116661666166116611111111111111771111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111611161116161116161116161111177711111171111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111611166616161666166616161111111111111177111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111166166611111ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111611161617771c1c11111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111666166611111c1c11111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111116161117771c1c11711111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111661161111111ccc17111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111161611111cc1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111616177711c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111161111111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111616177711c1117111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111161611111ccc171111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111161611111ccc1c1c11111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111116161777111c1c1c11111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111166611111ccc1ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111617771c11111c11711111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111166611111ccc111c17111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111616166616611666161611111c1c11111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111616116116161161161617771c1c11111111111111111111111111111111111111111111111111111111111111111111
111111111111111111111111111111111616116116161161166611111ccc11111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111166611611616116116161777111c11711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111166616661666116116161111111c17111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111116161666166611661616166611111ccc1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111116161611116116111616116117771c1c1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111116661661116116111666116111111ccc1111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111116161611116116161616116117771c1c1171111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111116161666166616661616116111111ccc1711111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111771111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111171111111111111111111111111111111111111111711111111111111111111111111111111111111111111111111111111111111111111
11111111111111111177111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111
11111111111111111171111111111111111111111111111111111111111777111111111111111111111111111111111111111111111111111111111111111111
11111111111111111771111111111111111111111111111111111111111777711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111771111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111661166616661616117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161616171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111616166116661616171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111616161616161666171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616161666117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111bb1b1111bb1171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111b111b111b111711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111b111b111bbb1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111b111b11111b1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111bb1bbb1bb11171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111bbb1bbb1bbb11711ccc11111ccc117111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111bbb1b1b1b1b17111c1c11111c1c111711111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111b1b1bbb1bbb17111c1c11111c1c111711111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111b1b1b1b1b1117111c1c11711c1c111711111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111b1b1b1b1b1111711ccc17111ccc117111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111111111bb1bbb1bbb1171166616111666161616661666111111661666111111111666161116661616166616661111161611111111166616111666
11111111111111111b111b1b1b1b1711161616111616161616111616111116111616111111111616161116161616161116161111161611111111161616111616
11111111111111111bbb1bbb1bb11711166616111666166616611661111116661666111111111666161116661666166116611111116111111111166616111666
1111111111111111111b1b111b1b1711161116111616111616111616111111161611117111111611161116161116161116161111161611711111161116111616
11111111111111111bb11b111b1b1171161116661616166616661616117116611611171111111611166616161666166616161171161617111111161116661616
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822288828228822288888888888888888888888888888888888888888888888888888888822282228882822282288222822288866688
82888828828282888888828288288828828288888888888888888888888888888888888888888888888888888888888282828828828288288282888288888888
82888828828282288888822288288828822288888888888888888888888888888888888888888888888888888888882282228828822288288222822288822288
82888828828282888888888288288828828288888888888888888888888888888888888888888888888888888888888282828828828288288882828888888888
82228222828282228888888282888222822288888888888888888888888888888888888888888888888888888888822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000000000000000181814001010100000000000000000000000000000005000000000101010101010100000000000000000000000001014000000000000000000008000008080008080005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000004040000001010100000000000000000000000000101000000000000000000000000000001010000000000000000000000000000000000040404000000000000000000000000000101010100000000000000000000000000000000008000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
432f2e2f2f2e2e2e2e2e2e2f2f2e2e2e2e2e2e2e2f2e2e2e2e2e2e2e2e2f2e2e2e2e2e2e2f2f2e2e2e2e2e2e2e2f2e2e2e2e2e2e2e2f2e2e2e2e2e2e2f2f2e2e2e2e2e2e2e2e2f2e2e2e2e2e2e2e2f2f2e2e2e2e2e2e2e2f2e2f2e2e2e2e2f2f2e2e2e2f2e2f2f2e2e2e2e2f2e2e2e2e2e2e2f2e2e2e2e2f2e2f2e2f2e2e2f43
432e2f2e2f2e2f2f2e2f2e2e2f2f2e2f2e2e2f2f2e2e2f2f2e2e2e2f2f2e2e2f2f2e2f2e2e2f2f2e2f2e2e2f2f2e2e2f2f2e2e2f2f2e2e2f2f2e2f2e2e2f2f2e2f2e2e2e2f2f2e2e2f2f2e2f2e2e2e2f2f2e2f2e2e2f2f2e2e2e2e2f2f2e2e2f2f2e2e2e2e2e2f2f2e2f2f2e2e2f2f2e2f2e2e2e2e2f2f2e2e2f2f2e2e2e2e43
432d2d2d2d2e2e2e2d2d2d2d2d2d2d2d2d2d2d2e2e2e2e2d2d2d2d2d2d2d2d2d2d2d2e2e2e2e2e2e2e2e2e2e2e2e2e2d2d2d2d2d2d2d2d2d2d2d2e2e2e2e2d2d2d2d2d2d2d2d2d2d2d2e2e2e2e2d2d2d2e2e2e2e2e2e2e2e2e2d2d2d2d2d2d2d2d2d2d2d2e2e2e2e2d2d2d2d2d2d2d2d2d2d2d2e2e2e2e2d2d2d2d2d2d2d2e43
433e3a3c3a3f1f3f3a3b3a3d3a3e3a3c3a3b3a2e3f1f3f3a3b3a3d3a3e3a3c3a3b3a2e3f1f3f2e2e2e2e2e2e3f1f3f3a3b3a3d3a3e3a3c3a3b3a2e3f1f3f3a3b3a3d3a3e3a3c3a3b3a2e3f1f3f3a3d3a3f2e2e2e2e2e3f1f3f3a3b3a3e3a3c3a3b3a3d3a2e3f1f3f3a3c3a3e3a3b3a3d3a3e3a2e3f1f3f3a3d3a3c3a3c3a2e43
43090a0b0a0a0a0b0b0a09090a0a0b0a09090a0b0a0a0a0b0b09090a0b0a0a0a0b0b0a09090a0a2e2e2e2e2e0b0a0a0a0b09090a0b0a0a0a0b0b0a09090a0a0b0a0909090a0b0a0a0a0b0b0a0909090a0a2e2e2e2e2e0b0a0a0a0a0a0b0b0a09090a0a0b0a090909090a0b0a0a0a0b0b0a090909090a0b0a0a0a0b0b0a090943
4319191919191919191919191919191919191919191919191919191919191919191919191919192e2e2e2e2e191919191919191919191919191919191919191919191919191919191919191919191919192e2e2e2e2e191919191919191919191919191919191919191919191919191919191919191919191919191919191c43
4326272a191919191919191919191919191926272a1919191919191919191926282a19191919192e2e2e242827282a191919191919191919191919191919192628292a19191919191919191919191919192e2e2e242827282a191919191919191919191919191919192628292a191919191919191919191919191919191d0c43
432b192c2628272a19191919191926282a192b192c1919191919191926282a2b192c19191919192e2e2e2b1919192c19262728282a191919191919191919192b19192c1926282a191919191919191919192e2e2e2b1919192c19262728282a191919191919191919192b19192c1926282a1919191919191919191c1c1d0c0c43
432b192c1919192c19191926272a2b192c192b192c19191926272a192b192c19192c1919262828252e2e2b1919192c192b1919192c192628272a19191919192b19192c192b192c19192628292a19262828252e2e2b1919192c192b1919192c192628272a19191919192b19192c192b192c19191919191919191d0c0c0c0c0c43
432b192c1919192c1919192b19192b192c192b192c1919192b192c192b192c19192c19192b19192c2e24272a19192c192b1919192c192b19192c19191919192b19192628292a2c19192b19192c192b19192c2e24272a19192c192b1919192c192b19192c19191919192b19192628292a2c191919191c1c1c1d0c0c0c0c0c0c43
432b192c1919192c1919192b191c2628272a2b192c1919192b26272a1926272a192c19192b19192c2e2b192c19192c192b1c1c1c2628272a192c191919191926282a1c1c1c1c2628272a19192c192b19192c2e2b192c19192c192b1c1c1c2628272a192c191919191926282a1c1c1c1c2c191c1c1d0c0c0c0c0c0c0c0c0c0c43
431c1c1c1c1c1c1c1c1c1c1c1d0c1e1c1c1c1c1c1c1c1c1b1b1c1c1c1c1c1c1c1b0d0e0e0e0f1b1b351b1b1b1c1c1c1c1d0c0c0c1e1c1c1c1b1b1b0d0e0e0f1b1b1b0c0c0c0c1e1c1c1c1b0d0e0e0e0f1b1b351b1b1b1c1c1c1c1d0c0c0c1e1c1c1c1b1b1b0d0e0e0f1b1b1b0c0c0c0c1e1d0c0c0c0c0c0c0c0c0c0c0c0c0c43
43c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c043
43c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c043
43c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c0c043
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4746464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464346464646464646464646464646464646464649
4344444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444344444444444444444444444444444444444443
4345454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454348484848484848484848484848484848484843
4345454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454348484848484848484848484848484848484843
4345454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454348484848484848484848484848484848484843
4345454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545474945454545454545454545454545454545454545454545454545454545454545454545454545454545454348484848484848484848484848484848484843
4345454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545454545474945454545454545454545454545454545454746464646494545454545454545454545454545454545454348484848484848484848484848484848484843
4345454545454545454545454545454545454545474945454746494545474649454547494545454545454545454545454545454545454545454545454545454545474945454545454545454545474646464945454746464646494545454545454545454545474649454547464346464948484746464646464649484847464649
4345454545454545454545454545454545454547464945454545454545454545454547464945454545454545454545454545454545454545454545434545454545474945454547464646494545474646464945454746464646494545454746464646494545474649454547464346464948484746464646464649484847464649
4345454545454545454545454545454545454746464945454545454545454545454547464649454545454545454545454545454545454545454547494545454545474945454547464646494545474646464945454746464646494545454746464646494545474649454547464346464948484746464646464649484847464649
4345454545454545454545454545454545474646464945454545454545454545454547464646494545454545454545454545454545454545454746494545454545474945454547464646494545474646464945454746464646494545454746464646494545474649454547464346464948484746464646464649484847464649
4345454545454545454545454545454547464646464945454545454545454545454547464646464646464646464646464945434543454345474646494545454545474945454547464646494545474646464945454746464646494545454746464646494545474649454547464346464948484746464646464649484847464649
434646464646464646464646464646464646464646498989898989898989898989894746464646464646464646464646498943894389438947464649898989898947498989894746464649898947464646498989474646464649898989474646464649898947464989894746434646498a8a47464646464646498a8a47464649
4346464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464649
__sfx__
000100003d0503705030050280502105019050130500e050080500405000050060500f05017050230502b05031050390503b0502d05020050150500c0500705001050060500c050150501e05028050340503e050
001000002a35023350233502a3501224015230182201a2102b32025330253402b3501b1501815015150131402c32025330253302c3301353016530185401b5302d33025330253402d3501c0501a0501705014050
001000000345009450094500e4501645025450324503d4502c35026350203501b35016350123500f3500c3502b5502c5502e550305502e5503055033550365502c55022550222501c2501c250192501335010350
b21000000000008350083500a3500b3500d3500f3501135015350193501b3502135000000273502a3502c3502f350313503335034350333502e3502b3501e350193501435012350103500f3500f3500f35010350
0010000000000000000c4500d4500f450114501245015450000001a4501b4501f4502145023450004002745024450104500d45009450064501140005450094500e45014450174501c45000400124500d4500d450
001000000d6500d6001060012600296000160024600256000060001600116001570016700187001a7001c7001e70020700237002470026700297002a7002d7002f7003070032700347003570037700397003b700
