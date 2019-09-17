import os

path = os.path.dirname(os.path.realpath(__file__))

os.system("DISPLAY=:1")
os.system("processing-java --force --sketch="+path +" --output="+os.getcwd()+"/out --run")