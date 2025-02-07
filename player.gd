extends CharacterBody2D

# Constantes para controlar a velocidade de movimento e a velocidade do pulo
const SPEED = 200  # A velocidade de movimento horizontal do personagem
const JUMP_VELOCITY = -500.0  # A velocidade do pulo (para cima, então é um valor negativo)

func _physics_process(delta: float) -> void:
	# Adiciona a gravidade quando o personagem não está no chão
	if not is_on_floor():
		velocity += get_gravity() * delta  # Acelera o personagem na direção da gravidade
		# Se o personagem está no ar, verifica se ele está se movendo
		if velocity.y < 0:
			$AnimatedSprite2D.animation = "jump"  # Define a animação de pulo enquanto sobe
		else:
			$AnimatedSprite2D.animation = "jump"  # Animação para quando o personagem está caindo

	# Verifica se o jogador pressionou o botão de pulo (geralmente "Enter" ou "Espaço")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Altera a velocidade vertical para realizar o pulo
		$AnimatedSprite2D.animation = "jump"  # Altera a animação para pulo ao pular

	# Obtém a direção do movimento (esquerda/direita) a partir das teclas pressionadas
	var direction := Input.get_axis("ui_left", "ui_right")  # Pega a entrada do jogador: -1 (esquerda), 1 (direita), 0 (parado)
	 
	if direction != 0:
		# Se o personagem está se movendo (direção diferente de 0):
		velocity.x = direction * SPEED  # Atualiza a velocidade horizontal com base na direção e na velocidade
		$AnimatedSprite2D.flip_h = direction < 0  # Se a direção for negativa (esquerda), inverte o sprite para olhar para a esquerda
		$AnimatedSprite2D.animation = "run"  # Muda a animação para "run" (correndo)
	else:
		# Se o personagem não está se movendo (direção é 0):
		velocity.x = move_toward(velocity.x, 0, SPEED)  # Acelera o personagem em direção a 0 (parado)
		if is_on_floor():  # Se estiver no chão, muda a animação para "idle"
			$AnimatedSprite2D.animation = "default"  # Muda a animação para "idle" (parado)

	# Move o personagem levando em consideração a física (gravidade, colisões, etc.)
	move_and_slide()  # Atualiza a posição do personagem com base na velocidade calculada
