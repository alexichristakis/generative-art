int frame;
int NOISE_SCALE = 800;
color[] colors = { color(69,33,124), color(7,153,242), color(255) };
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
    color col;
    float speed, index, size, progress, offset;

    Box(int index, float size) {
        this.size = size;
        this.index = index;
        this.speed = random(0.01, 0.2);
        this.offset = random(1, 50);
        this.progress = 0;
        this.col = colors[(int) random(0, 2)];
    }

    void draw(float top) {
        float offsetProgress = max(map(progress, 0, 1, offset, 0), 0);
        float fillProgress = min(map(progress, 0, 0.5, 0, size), size);

        fill(0);
        rect(index * size, top + offsetProgress, size, size);

        fill(255);
        rect(index * size, top + offsetProgress, size, size - fillProgress);

        strokeWeight(4);
        fill(0);

        float cx = index * size + size / 2;
        float cy = top + offsetProgress + size / 2;

        float x2 = map(cos(progress), -1, 1, cx - size / 2, cx + size / 2);
        float y2 = map(sin(progress), -1, 1, cy - size / 2, cy + size / 2);
        // circle(cx, cy, offsetProgress - size);
        line(cx, cy, x2, y2);


        progress += speed;
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

    if (frame % 60 == 0) {
        if (availHeight / 2 > 30) {
            Row prevRow = rows.get(0);
            Row newRow = new Row(random(10, availHeight / 2), prevRow.top + prevRow.rowSize);
            rows.add(0, newRow);
        }

        frame = 0;  
    }

    for (Row row : rows) {
        row.draw();
    }

    frame++;
}