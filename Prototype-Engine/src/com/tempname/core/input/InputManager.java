package com.tempname.core.input;

import com.tempname.core.input.listeners.*;

import java.util.ArrayList;

public class InputManager {

    public ArrayList<MouseClickedListener> mouseClickedListeners;
    public ArrayList<MousePressedListener> mousePressedListeners;
    public ArrayList<MouseReleasedListener> mouseReleasedListeners;
    public ArrayList<KeyPressedListener> keyPressedListeners;
    public ArrayList<KeyReleasedListener> keyReleasedListeners;
    public ArrayList<MouseScrollListener> mouseScrollListeners;

    public InputManager() {
        this.clearAllListeners();
    }

    public void registerListener(MouseClickedListener listener) {
        mouseClickedListeners.add(listener);
    }

    public void registerListener(MousePressedListener listener) {
        mousePressedListeners.add(listener);
    }

    public void registerListener(MouseReleasedListener listener) {
        mouseReleasedListeners.add(listener);
    }

    public void registerListener(KeyPressedListener listener) {
        keyPressedListeners.add(listener);
    }

    public void registerListener(KeyReleasedListener listener) {
        keyReleasedListeners.add(listener);
    }

    public void registerListener(MouseScrollListener listener) {
        mouseScrollListeners.add(listener);
    }



    public void clearAllListeners() {
        clearMouseClickedListeners();
        clearMousePressedListeners();
        clearMouseReleasedListeners();
        clearKeyPressedListeners();
        clearKeyReleasedListeners();
        clearMouseScrollListeners();
    }

    public void clearMouseClickedListeners() {
        mouseClickedListeners = new ArrayList<MouseClickedListener>();
    }

    public void clearMousePressedListeners() {
        mousePressedListeners = new ArrayList<MousePressedListener>();
    }

    public void clearMouseReleasedListeners() {
        mouseReleasedListeners = new ArrayList<MouseReleasedListener>();
    }

    public void clearKeyPressedListeners() {
        keyPressedListeners = new ArrayList<KeyPressedListener>();
    }

    public void clearKeyReleasedListeners() {
        keyReleasedListeners = new ArrayList<KeyReleasedListener>();
    }

    public void clearMouseScrollListeners() {
        mouseScrollListeners = new ArrayList<MouseScrollListener>();
    }
}