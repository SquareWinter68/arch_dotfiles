from PIL import Image, ImageSequence
import random

def extract_random_frame(gif_path, output_path):
    # Open the GIF file
    with Image.open(gif_path) as gif:
        # Get the number of frames in the GIF
        num_frames = gif.n_frames

        # Choose a random frame index
        random_frame_index = random.randint(0, num_frames - 1)

        # Extract the selected frame
        gif.seek(random_frame_index)
        frame = gif.copy()

        # Save the frame as a PNG
        frame.save(output_path, format="PNG")

if __name__ == "__main__":
    # Specify the path to your GIF file
    gif_file_path = "path/to/your/animated.gif"

    # Specify the output path for the PNG file
    output_png_path = "path/to/save/random_frame.png"

    # Call the function to extract and save a random frame
    extract_random_frame(gif_file_path, output_png_path)
