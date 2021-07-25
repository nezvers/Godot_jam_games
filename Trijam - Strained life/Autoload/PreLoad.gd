extends Node

#------Scenes-----
var jumpParticleScene: = preload("res://Player/JumpParticles.tscn")
var landParticleScene: = preload("res://Player/LandParticles.tscn")

#------AUDIO------
var snd_BombBounce: = preload("res://Assets/SFX/BombBounce.wav")
var snd_Explosion: = preload("res://Assets/SFX/Explosion.wav")
var snd_Jump: = preload("res://Assets/SFX/Jump_01.wav")
var snd_Landing: = preload("res://Assets/SFX/Landing.wav")
var snd_SpawnBomb: = preload("res://Assets/SFX/SpawnBomb.wav")
var snd_Step1: = preload("res://Assets/SFX/Steps_01.wav")
var snd_Step2: = preload("res://Assets/SFX/Steps_02.wav")
var snd_Step3: = preload("res://Assets/SFX/Steps_03.wav")
var snd_Step4: = preload("res://Assets/SFX/Steps_04.wav")
var snd_StepL1: = preload("res://Assets/SFX/Steps_slower_01.wav")
var snd_StepL2: = preload("res://Assets/SFX/Steps_slower_02.wav")
var snd_StepL3: = preload("res://Assets/SFX/Steps_slower_03.wav")
var snd_StepL4: = preload("res://Assets/SFX/Steps_slower_04.wav")
var snd_Splash1: = preload("res://Assets/SFX/Splash_1.wav")
var snd_Splash2: = preload("res://Assets/SFX/Splash_2.wav")
var snd_Splash3: = preload("res://Assets/SFX/Splash_3.wav")
var snd_Die: = preload("res://Assets/SFX/Explode.wav")
var snd_Coin: = preload("res://Assets/SFX/Coin.wav")
var snd_Charging: = preload("res://Assets/SFX/Charging.wav")
