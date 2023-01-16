// (c) 2023 Joseph HENRY
// This code is licensed under MIT license (see LICENSE for details)

// Dodeka music notation from: https://www.dodekamusic.com

import processing.sound.*;
import java.util.List;

final int NNOTES = 12;

final float NOTE_WIDTH = 35;
final float NOTE_HEIGHT = NOTE_WIDTH / 8;

// Note durations
final float CROTCHET = 1 / 4f;
final float QUAVER = CROTCHET / 2;
final float SEMI_QUAVER = QUAVER / 2;
final float DEMI_SEMI_QUAVER = SEMI_QUAVER / 2;

final float CROTCHET_WIDTH = CROTCHET * NOTE_WIDTH;

class Note {
  float time;
  int pitch;
  float duration;

  Note(float time, int pitch, float duration) {
    this.time = time;
    this.pitch = pitch;
    this.duration = duration;
  }

  float width() {
    return NOTE_WIDTH * duration;
  }

  float start() {
    return time * NOTE_WIDTH;
  }

  float end() {
    return start() + width();
  }
}

class Staff {
  float gap = 5;
  float barHeight = NOTE_HEIGHT * 2;
  float baseFrequency;

  float x, y;

  TriOsc sineOsc;
  List<Note> notes = new ArrayList<Note>();

  Staff(PApplet p, float x, float y, float baseFrequency) {
    sineOsc = new TriOsc(p);
    sineOsc.play();
    this.x = x;
    this.y = y;
    this.baseFrequency = baseFrequency;
  }

  Note lasNote() {
    if (notes.size() == 0) return null;
    Note lastNote = notes.get(0);

    for (Note note : notes) {
      if (note.time > lastNote.time) lastNote = note;
    }

    return lastNote;
  }

  void display(float time) {
    Note lastNote = lasNote();
    Note currentPlayingNote = null;

    float lastNoteEnd = lastNote.time + lastNote.duration;
    float w = gap * 2 + lastNote.end();
    float timelineX = x + time * w;

    noFill();
    stroke(0);
    for (int i = 0; i < 3; i++) {
      rect(x, y + i * barHeight, w, barHeight);
    }

    noStroke();   
    for (int n = 0; n < notes.size(); n++) {
      Note note = notes.get(n);

      float notePos = note.time / lastNoteEnd;
      color fill = lerpColor(#845ec2, #faccff, note.pitch / (float) NNOTES);

      if (time >= notePos && time <= notePos + note.duration / lastNoteEnd) {
        fill = color(0, 255, 0);
        currentPlayingNote = note;
      }

      float nx = x + gap + note.start();
      float ny = y - NOTE_HEIGHT / 2.0 + (NNOTES - note.pitch) * NOTE_HEIGHT / 2.0;

      // We display a half note if greater than one 
      if (note.duration > CROTCHET) {
        fill(255);
        rect(nx, ny, note.width(), NOTE_HEIGHT);

        int nDivs = round(note.duration / CROTCHET);
        int arrowSize = 5;
        int arrowGap = 3;

        fill(fill);
        for (int i = 0; i < nDivs; i++) {
          boolean first = i == 0;
          boolean last = i == nDivs - 1;

          float startX = nx + i * CROTCHET_WIDTH;
          float realStartX = first ? startX : startX - arrowSize + arrowGap;
          float endX = startX + CROTCHET_WIDTH;
          float realEndX = last ? endX : endX - arrowSize;

          beginShape();
          vertex(realStartX, ny);
          vertex(realEndX, ny);
          if (!last) vertex(endX, ny + NOTE_HEIGHT / 2);
          vertex(realEndX, ny + NOTE_HEIGHT);
          vertex(realStartX, ny + NOTE_HEIGHT);
          if (!first) vertex(startX + arrowGap, ny + NOTE_HEIGHT / 2);
          endShape();
        }
      } else {
        fill(fill);
        rect(nx, ny, note.width(), NOTE_HEIGHT);
      }
    }

    // Display timeline
    stroke(255, 0, 0);
    line(timelineX, y, timelineX, y + barHeight * 3);

    // Set frequency
    sineOsc.freq(currentPlayingNote != null ? map(currentPlayingNote.pitch, 0, NNOTES, baseFrequency, baseFrequency + 1000) : 0);
  }
}

float animValue = 0;
Staff staff;
List<Staff> staffs = new ArrayList<Staff>();

void setup() {
  size(400, 400);

  noiseDetail(8, 0.2);

  int nStaffs = 10;
  float gap = 12;
  float staffWidth = width - gap * 2;
  float maxDuration = staffWidth / NOTE_WIDTH;

  for (int j = 0; j < nStaffs; j++) {
    Staff staff = new Staff(this, gap, gap + j * (3 * NOTE_HEIGHT + gap * 2), j * 100);

    float totalDuration = 0;
    for (int i = 0; i < NNOTES * 2; i++) {
      float fac = (i / (float)NNOTES * 2) * 5;
      float offset = j * 3;

      float duration = pow(2, noise(fac + offset) * j * 0.55 - 1) * CROTCHET;
      float pitch = noise(fac + offset) * NNOTES;
      staff.notes.add(new Note(min(totalDuration, maxDuration), int(pitch), duration));
      totalDuration += duration + random(0.05, 0.1);

      if (totalDuration > maxDuration) break;
    }

    staffs.add(staff);
  }
}

void draw() {
  background(#fbeaff);

  for (Staff staff : staffs) staff.display(animValue % 1);

  animValue += 0.005;
}
