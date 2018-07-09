

startup_rvc;
cam = Movie('traffic_sequence.mpg', 'double', 'grey');
im1=cam.grab();
im2=cam.grab();

imshow(im1-im2);