<?php

namespace Database\Seeders;

#region USE

use Illuminate\Database\Seeder;
use Narsil\Models\Hosts\Host;
use Narsil\Models\Hosts\HostLocale;
use Narsil\Models\Hosts\HostLocaleLanguage;

#endregion

final class HostSeeder extends Seeder
{
    #region PUBLIC METHODS

    /**
     * @return void
     */
    public function run(): void
    {
        $data = $this->getData();

        foreach ($data as $item)
        {
            $host = Host::firstOrCreate([
                Host::HANDLE => $item[Host::HANDLE],
            ], [
                Host::NAME => $item[Host::NAME],
            ]);

            foreach ($item[Host::RELATION_LOCALES] as $key => $locale)
            {
                $hostLocale = HostLocale::firstOrCreate([
                    HostLocale::COUNTRY => $locale[HostLocale::COUNTRY],
                    HostLocale::HOST_ID => $host->{Host::ID},
                    HostLocale::PATTERN => $locale[HostLocale::PATTERN],
                    HostLocale::POSITION => $key,
                ]);

                foreach ($locale[HostLocale::RELATION_LANGUAGES] as $language)
                {
                    HostLocaleLanguage::firstOrCreate([
                        HostLocaleLanguage::LANGUAGE => $language,
                        HostLocaleLanguage::LOCALE_ID => $hostLocale->{HostLocale::ID},
                        HostLocaleLanguage::POSITION => $key,
                    ]);
                }
            }
        }
    }

    #endregion

    #region PRIVATE METHODS

    /**
     * @return array
     */
    private function getData(): array
    {
        $domain = parse_url(config('app.url'), PHP_URL_HOST);

        return [
            [
                Host::HANDLE => $domain,
                Host::NAME => 'Multisite',
                Host::RELATION_LOCALES => [
                    [
                        HostLocale::COUNTRY => 'default',
                        HostLocale::PATTERN => 'https://{host}/{language}',
                        HostLocale::RELATION_LANGUAGES => ['en', 'de', 'fr'],
                    ],
                    [
                        HostLocale::COUNTRY => 'DE',
                        HostLocale::PATTERN => 'https://{host}/{language}-{country}',
                        HostLocale::RELATION_LANGUAGES => ['de', 'en'],
                    ],
                    [
                        HostLocale::COUNTRY => 'FR',
                        HostLocale::PATTERN => 'https://{host}/{language}-{country}',
                        HostLocale::RELATION_LANGUAGES => ['fr', 'en'],
                    ],
                    [
                        HostLocale::COUNTRY => 'GB',
                        HostLocale::PATTERN => 'https://{host}/{language}-{country}',
                        HostLocale::RELATION_LANGUAGES => ['en'],
                    ],
                ],
            ],
            [
                Host::HANDLE => "landingpage.$domain",
                Host::NAME => 'Landing page',
                Host::RELATION_LOCALES => [
                    [
                        HostLocale::COUNTRY => 'default',
                        HostLocale::PATTERN => 'https://{host}/{language}',
                        HostLocale::RELATION_LANGUAGES => ['en', 'de', 'fr'],
                    ],
                ],
            ],
        ];
    }

    #endregion
}
