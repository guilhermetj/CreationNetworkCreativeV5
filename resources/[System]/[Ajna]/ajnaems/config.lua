Config = {}

-- ATTENTION: Key control to stop the animation can be changed by the player through the game menu (settings > key bindings > fivem)
-- Default key is F6

-- ATENÇÃO: O controle para parar as animações pode ser alterado pelo próprio player nas configurações no menu do jogo (configurações > teclado > fivem)
-- O controle padrão é F6


---------- GENERAL CONFIG | CONFIGURAÇÃO GERAL

-- Language (default is 'en' for english translation)
-- Idioma (coloque 'br' para exibir o texto em português)
Config.Locale = 'en'

-- You can alter the animation command here (default: /ems)
-- Você pode alterar o comando da animação aqui (padrão: /ems)
Config.CommandName = 'ems'


---------- DEFIBRILLATOR SOUND CONFIG | CONFIGURAÇÃO DE SOM DO DESFIBRILADOR

-- Set this to true if you want to enable the defibrillator sound (requires xSound - https://github.com/Xogy/xsound)
-- Altere para true se você quiser ativar o som do desfibrilador (requer o xSound - https://github.com/Xogy/xsound)
Config.UseXSound = true

-- Only change this if you want to use another defibrillator sound (Config.UseXSound must be true)
-- Altere o link apenas se você quiser usar outro som para o desfibrilador (Config.UseXSound deve estar como true)
Config.DefibSoundUrl = 'https://www.youtube.com/watch?v=yRqaNhcdrpE'

-- Sound duration in seconds
-- Duração do som em segundos
Config.SoundDuration = 3

-- Sound max volume
-- Volume máximo do som
Config.SoundMaxVolume = 0.4

-- Sound max distance
-- Distância máxima em que o som será ouvido
Config.SoundMaxDistance = 5.0