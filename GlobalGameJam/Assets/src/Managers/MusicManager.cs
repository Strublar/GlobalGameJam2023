using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicManager : MonoBehaviour
{
    [SerializeField] private AudioSource gameMusic;
    [SerializeField] private AudioSource deathMusic;
    [SerializeField] private List<AudioSource> cutSounds;

    public void StartGameMusic()
    {
        gameMusic.loop = true;
        gameMusic.Play();
    }

    public void Death()
    {
        var audioMixer = gameMusic.outputAudioMixerGroup.audioMixer;
        audioMixer.TransitionToSnapshots(new []{audioMixer.FindSnapshot("Death")}, new []{5f}, 1f);
        StopGameMusic();
        // PlayDeath();
    }

    public void StopGameMusic()
    {
        gameMusic.loop = false;
        gameMusic.Stop();
    }

    public void PlayDeath()
    {
        deathMusic.Play();
    }

    public void playRandomCutSound()
    {
        cutSounds[Random.Range(0, cutSounds.Count)].Play();
    }

}