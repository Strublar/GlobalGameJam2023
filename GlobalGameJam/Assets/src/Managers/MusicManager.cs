using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

public class MusicManager : MonoBehaviour
{
    [SerializeField] private AudioSource gameMusic;
    [SerializeField] private AudioSource deathMusic;
    [SerializeField] private List<AudioSource> cutSounds;

    private void Awake()
    {

        DontDestroyOnLoad(this.gameObject);
    }

    public void StartGameMusic()
    {
        gameMusic.loop = true;
        var playSnapshot = gameMusic.outputAudioMixerGroup.audioMixer.FindSnapshot("Play");
        playSnapshot.TransitionTo(0);
        
        gameMusic.Play();
    }

    public void Death()
    {
        var audioMixer = gameMusic.outputAudioMixerGroup.audioMixer;
        var deadSnapshot = audioMixer.FindSnapshot("Dead");
        audioMixer.TransitionToSnapshots(new []{ deadSnapshot}, new []{5f}, 1f);
        PlayDeath();
  
    }
    public void Retry()
    {
        var audioMixer = gameMusic.outputAudioMixerGroup.audioMixer;
        var gameSnapshot = audioMixer.FindSnapshot("Play");
        gameSnapshot.TransitionTo(0);
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