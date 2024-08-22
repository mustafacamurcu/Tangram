extends Node


# Game Events
signal piece_picked_up(piece: Piece)
signal piece_put_down(piece: Piece)
signal level_completed(level: Level)

# UI Events
signal start_pressed
signal restart_pressed
signal level_selected(level: Level)
signal level_selection_pressed
signal next_level_pressed
signal quit_pressed
signal back_to_menu_pressed
signal tutorial_pressed
signal escape_pressed

# Audio
signal menu_button_clicked
signal bgm_changed(value)
signal sfx_changed(value)
