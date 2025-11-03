#!/bin/bash
# --------------------------------------------------------------
# Dual Output Audio Manager (Zenity GUI)
# For PipeWire-based Ubuntu systems
# --------------------------------------------------------------

set -e
trap 'cleanup_audio' EXIT

DEFAULT_DELAY_MS=180

cleanup_audio() {
    pactl unload-module module-loopback 2>/dev/null || true
    pactl unload-module module-combine-sink 2>/dev/null || true
}

check_pipewire() {
    if ! pactl info | grep -q "on PipeWire"; then
        zenity --warning --text="PipeWire not detected. This script is for PipeWire-based systems."
    fi
}

# Get list of sinks
get_sinks() {
    pactl list short sinks | awk '{print $1 ":" $2}'
}

# Apply delay
apply_delay() {
    local sink=$1
    local delay=$2
    pactl load-module module-loopback sink="$sink" latency_msec="$delay" 2>/dev/null || {
        zenity --error --text="Failed to apply delay."
        exit 1
    }
}

check_pipewire
cleanup_audio

# Ask user to pick sinks
sink_list=$(get_sinks)
if [[ -z "$sink_list" ]]; then
    zenity --error --text="No audio sinks found. Connect your devices and try again."
    exit 1
fi

jack_id=$(echo "$sink_list" | zenity --list --title="Select 3.5mm Output" --column="Sink ID:Name" --height=400)
bt_id=$(echo "$sink_list" | zenity --list --title="Select Bluetooth Output" --column="Sink ID:Name" --height=400)

if [[ -z "$jack_id" || -z "$bt_id" ]]; then
    zenity --error --text="Selection cancelled or invalid."
    exit 1
fi

jack_sink=$(echo "$jack_id" | cut -d: -f2)
bt_sink=$(echo "$bt_id" | cut -d: -f2)

combine_id=$(pactl load-module module-combine-sink slaves="$jack_sink,$bt_sink" adjust_time=1 latency_compensate=true)
sleep 1

# Choose delay target
delay_choice=$(zenity --list \
    --title="Select Delay Target" \
    --text="Which output should get the delay?" \
    --radiolist \
    --column="Select" --column="Output" TRUE "3.5mm Jack" FALSE "Bluetooth" FALSE "No Delay" \
    --height=400)

case "$delay_choice" in
    "3.5mm Jack") delay_target="$jack_sink" ;;
    "Bluetooth") delay_target="$bt_sink" ;;
    "No Delay") delay_target="" ;;
    *) delay_target="$jack_sink" ;;
esac

if [[ -n "$delay_target" ]]; then
    delay_ms=$(zenity --entry --title="Set Delay" --text="Enter delay in milliseconds:" --entry-text="$DEFAULT_DELAY_MS")
    delay_ms=${delay_ms:-$DEFAULT_DELAY_MS}
    apply_delay "$delay_target" "$delay_ms"
    zenity --info --text="Dual output active!\nDelay: ${delay_ms}ms applied to ${delay_choice}."
else
    zenity --info --text="Dual output active with no delay applied."
fi

zenity --question --text="Dual output mode is running.\nPress OK to stop and restore normal audio." --ok-label="Stop" --cancel-label="Keep Running"
if [[ $? -eq 0 ]]; then
    cleanup_audio
    zenity --info --text="Audio restored to normal."
fi









