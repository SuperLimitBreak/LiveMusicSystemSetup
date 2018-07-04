from calaldees.animation.timeline import Timeline

META = {
    'name': 'test',
    'bpm': 120,
    'timesignature': '4:4',
}


def create_timeline(dc, t, tl, el):
    # TODO: Demo all lights cycling colors
    tl = tl * 5

    # TODO: example image cycling to lights
    el.add_trigger({
        "deviceid": "main",
        "func": "image.start",
        "src": "test_image.png",
        "timestamp": t('0.0.0'),
    })

    return tl
