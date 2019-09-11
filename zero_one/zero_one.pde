int frame;
ArrayList<Row> rows = new ArrayList<Row>();

class Row {
    Box[] boxes;
    float rowSize, numCells, top;

    Row(float rowSize, float top) {
        this.rowSize = rowSize;
        this.top = top;

        int numCells = (int) (width / rowSize) + 1;
        boxes = new Box[numCells];
        for (int i = 0; i < boxes.length; i++) {
            boxes[i] = new Box(i, rowSize);
        }
    }

    void draw() {
        top -= 60 / (frame + 10);
        for (int i = 0; i < boxes.length; i++) {
            boxes[i].draw(top);
        }
    }
}


class Box {
    float speed, index, size, progress, offset;

    Box(int index, float size) {
        this.size = size;
        this.index = index;
        this.speed = random(0.1, 0.8);
        this.offset = random(1, 50);
        this.progress = 0;
    }

    void draw(float top) {
        float offsetProgress = map(progress, 0, 2, offset, 0);
        float fillProgress = min(map(progress, 0, 0.5, 0, size), size);

        fill(0);
        rect(index * size, top + offsetProgress, size, size);

        fill(255);
        rect(index * size, top + offsetProgress, size, size - fillProgress);

        strokeWeight(4);
        circle(index * size + size / 2, top + offsetProgress + size / 2, size / 2);

        if (progress < 2 && progress + speed / 6 < 2) {
            progress += speed / 6;
        } else {
            progress = 2;
        }
    }
}

void setup() {
    size(1000,1000);
    background(0);

    frame = 0;
    rows.add(new Row(random(10, 100), height / 2));
}

float updateRows(ArrayList<Row> rows) {
    for (int i = rows.size() - 1; i > 0; i--) {
        Row row = rows.get(i);
        if (row.top + row.rowSize < 0) {
            rows.remove(i);
        }
    }


    float rowsHeight = 0;
    for (Row row : rows) rowsHeight += row.rowSize;

    return rowsHeight;
}


void draw() {
    background(0);
    fill(0);
    stroke(255);

    float rowsHeight = updateRows(rows);
    float availHeight = height - rowsHeight;

    if (availHeight / 2 > 30 && frame % 60 == 0) {
        Row prevRow = rows.get(0);
        Row newRow = new Row(random(10, availHeight / 2), prevRow.top + prevRow.rowSize);
        rows.add(0, newRow);

        frame = 0;  
    }

    for (Row row : rows) {
        row.draw();
    }

    frame++;
}