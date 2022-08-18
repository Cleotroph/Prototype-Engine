package com.tempname.core;

import com.tempname.core.input.INPUT;
import com.tempname.core.input.listeners.*;
import processing.core.PApplet;
import processing.event.MouseEvent;

public class Window extends PApplet {
    @Override
    public void settings() {
        super.settings();
    }

    @Override
    public void setup() {
        super.setup();
    }

    @Override
    public void draw() {
        super.draw();
    }

    public void mouseClicked() {
        for (MouseClickedListener listener : INPUT.ActiveInputManager.mouseClickedListeners) {
            listener.onMouseClicked();
        }
    }

    public void mousePressed() {
        for (MousePressedListener listener : INPUT.ActiveInputManager.mousePressedListeners) {
            listener.onMousePressed();
        }
    }

    public void mouseReleased() {
        for (MouseReleasedListener listener : INPUT.ActiveInputManager.mouseReleasedListeners) {
            listener.onMouseReleased();
        }
    }

    public void keyPressed() {
        for (KeyPressedListener listener : INPUT.ActiveInputManager.keyPressedListeners) {
            listener.onKeyPressed();
        }
    }

    public void keyReleased() {
        for (KeyReleasedListener listener : INPUT.ActiveInputManager.keyReleasedListeners) {
            listener.onKeyReleased();
        }
    }

    public void mouseWheel(MouseEvent event) {
        for (MouseScrollListener listener : INPUT.ActiveInputManager.mouseScrollListeners) {
            listener.onMouseScroll(event.getCount());
        }
    }
}
