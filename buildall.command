wd="$(dirname "$0")/vignettes"

vignettes=(
	bubble_tab_bar
	constellations_list
	dark_ink_transition
	drink_rewards_list
	fluid_nav_bar
	gooey_edge
	parallax_travel_cards_hero
	parallax_travel_cards_list
	particle_swipe
	ticket_fold
)

for i in ${vignettes[@]}; do
  cd "${wd}/${i}"
  echo "building ${i}"
  flutter build web
done
