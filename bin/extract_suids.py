#!/usr/bin/python

import sys, subprocess, os, re, json

def writeJSON(data, student):
    with open('%s/info.json' % student, 'w') as outfile:
        json.dump(data, outfile, indent=4)

student_dir = os.path.abspath(sys.argv[1])
students = ['%s/%s' % (student_dir, x) for x in os.walk(student_dir).next()[1]]
suid_pattern = re.compile('Student ID : (\d+)')
for student in students:
    json_data = open('%s/info.json' % student)
    data = json.load(json_data)
    json_data.close()
    if 'posted' not in data:
        data['posted'] = False
        writeJSON(data, student)

    if 'suid' not in data['student']:
        src = '%s/transcript.pdf' % student
        dst = '%s/transcript.txt' % student
        photo = '%s/photo.jpg'
        print student

        # autoorient the photo if possible
        if os.path.isfile(photo):
            subprocess.call(['convert', '%s/photo.jpg' % student, '-auto-orient', '%s/photo.jpg' % student])

        failed = subprocess.call(['pdftotext', src, dst])
        if not failed:
            transcript = ''
            with open(dst, 'r') as f:
                transcript = f.read()
        
        match = suid_pattern.search(transcript)
        suid = -1
        if match:
            suid = int(match.group(1))
        else:
            print 'Failed for %s' % student
            continue

        data['student']['suid'] = suid
        writeJSON(data, student)
