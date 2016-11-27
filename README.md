# gesundheit.space

![](https://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/000/449/987/datas/gallery.jpg)

## Inspiration

There are gazillions of different devices and services to track your health and fitness data. Additionally, there are dozens of services to display your raw health data using fancy graphics and sophisticated animations. But why don’t you use them?

In a classical Finnish sauna business meeting, we figured out that the way to help you with your health is not to show you even more diagrams, bar charts and tables but to [keep it simple (, stupid)](https://en.wikipedia.org/wiki/KISS_principle). That is why we came up with **Ges::ndheit**.

Well, let us introduce **Ges::ndheit**:

## What it does

**Ges::ndheit** is the solution for all of your health problems. It’s the swiss army knife of the personal assistant apps. It is the last ray of sun before the cold night (which is like 4pm in Finland).

**Ges::ndheit** solves the information overload of all those smart devices you own by reducing all of the available data into **one clear personalized instruction** on how **you can improve your health**. Those instructions vary from simple text-based recommendations up to adjustments of your SmartHome devices. The personalized instructions are constructed by a recommendation algorithm that combines your health and context data with research, cohort and health consultant data. The impact of the recommendation algorithm can be leveraged further by any data about you and your environment. 

## How we built it

As a team of five developers we split work into three main areas: **Backend**, **iOS App & Design**.

### Backend

Our backend team was mainly focused on getting as much information as possible from various data sources (OURA, Isaacus, Kanta, Localtapiola, Tieto & ISS, Apple HealthKit and many more). This information was highly heterogenous, thus we had to clean, restructure and combine it before we could use it in our classification algorithm.

This algorithm had to be developed as well. It is responsible for detecting the benchmarks for a good health that we could compare the user's data to. The algorithm uses clustering to detect cohorts of similar people.

To get access to those values, a REST-API was created as well.

### App

Following our idea of simplifying the large amounts of daily health data, our app reduces distraction by using a simplistic design. It lets you concentrate on living a healthy life. All you have to do to live a healthier life is to allow **Ges::ndheit** access to HealthKit and (optionally) Kanta. The app then automatically fetches your data and compares it with other patients’ data in our backend to generate a personalized instruction just for you.

Performance-wise the whole app is 100% pure Swift in order to run as fast as possible.

## Challenges we ran into

There were a lot of technical difficulties in making the data look pretty, so it is comparable and clusterable. Mistakes in some datasets (e.g. 500kg+ body weight) made it even more difficult for us, as we had to clean the data using outlier detection.

Another challenge was that some of the IOT devices we wanted to use were either not provided (e.g. the Nest thermostat) or already taken (e.g. the Amazon Echo). The former could be solved by creating a Nest Thermostat Simulator which is now accessed by our API instead of the real technical device.

## Accomplishments that we're proud of

Our team worked very well, as everybody had distinct expertises that combined covered the whole range from Design, over Frontend, Apps, and Backend to Machine Learning.

As mentioned above, the backend team worked hard on the implementation of an algorithm to find groups of user types and to match you in one of those to find reference values. We think that we came up with a very good solution considering the time we could spent on it.

Finally, we believe that **Ges::ndheit** can have a huge impact on overall global health and could make the world a better place by producing healthier residents.

## What we learned

If you go to Finland take enough money with you, as beer is really expensive there.

## What's next for Ges::ndheit

**Ges::ndheit** made us realize that there is a lot of **.space** for improvements in current HealthTech applications and services. As it is open source, we hope that it can help to inspire other developers to improve current health and fitness applications to be more personalized and thus more valuable to its users.

## Radix

Hey Radix guys, our URL is: http://gesundheit.space :)


# Get started
Build frameworks

```
$ carthage update 
```
