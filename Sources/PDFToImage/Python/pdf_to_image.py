import fitz
import click
from PIL import Image
import os

def covertPageToPILImage(page: fitz.Page):
    fitz.Matrix()

class PDFImageConverter:
    def __init__(self, rotate: int = 0, zoom_x: int = 4, zoom_y: int = 4, mode: str = "RGB", format: str = "PNG") -> None:
        self.rotate = rotate
        self.zoom_x = zoom_x
        self.zoom_y = zoom_y
        self.mode = mode
        self.format = format

    def convertPageToImage(self, page: fitz.Page)->Image:
        matrix = fitz.Matrix(self.zoom_x, self.zoom_y).prerotate(self.rotate)
        pixel_map = page.get_pixmap(matrix=matrix, alpha=False)
        return Image.frombytes(mode=self.mode, size=[pixel_map.width, pixel_map.height], data=pixel_map.samples)
    

    def convert(self, id: str):
        try:
            os.mkdir(f"/tmp/{id}")
        except Exception as error:
            print("error:", error)
            pass
        with open(f"/tmp/{id}.pdf", "rb") as fp:
            pdf_bytes = fp.read()
            document = fitz.open(stream=pdf_bytes)

            for index, page in enumerate(document):
                image = self.convertPageToImage(page)
                if(image):
                    image.save(f"/tmp/{id}/{index}.png")
        

@click.command()
@click.option('--id', 'id', help='id', required=True)
def convert(id: str):
    converter = PDFImageConverter()
    converter.convert(id=id)

if __name__ == "__main__":
    convert()