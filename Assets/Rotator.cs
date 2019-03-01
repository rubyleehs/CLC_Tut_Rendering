using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour {
    public float speed;
    void Update () {
        this.transform.Rotate (0, 0, speed * Time.deltaTime);
    }
}