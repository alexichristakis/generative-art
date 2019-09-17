# Processing programs for the Becton Cafe LED display
In order to run these visualizations in Visual Studio Code:
1. install processing-java
2. install VS Code processing extension
3. https://github.com/TobiahZ/processing-vscode

To run on a Raspberry Pi:

Execute: `curl https://processing.org/download/install-arm.sh | sudo sh` to ensure processing-java is installed on the Pi.

in: `/etc/xdg/lxsession/LXDE-p/autostart` add a line: `@python PATH_TO_START_SCRIPT`
and also add a script `start.py` with the code:

```
import os

path = os.path.dirname(os.path.realpath(__file__))

os.system("DISPLAY=:1")
os.system("processing-java --force --sketch="+path+" --output="+path+"/out --run")
```

This will run the visualization on boot.

### My two favorite visualizations are:
## cells
Renders circles that grow, divide, mutate, get sick, and die. A cell's color is dictated by its dna. Each division has the chance to mutate the dna of the daughter cells. A sick cell has the chance to infect other cells after a collision if they're genetically similar.

## wave_sim
An attempt to simulate the topography of waves on the surface of a body of water. Points are drawn in 4 dimensions (x, y, z, color) with the z and color dimensions mapped to a perlin noise function. To map the visualization to the becton space, two regions are drawn: one to account for the panels in the hallway, and one to account for the large panel in the cafe. 

Videos: https://drive.google.com/drive/folders/1n2tfZnRGVDYvmHAQN-sr9ty9tVwch21L?usp=sharing